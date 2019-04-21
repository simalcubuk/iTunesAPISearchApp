//
//  ItemListViewController.swift
//  DolapProject
//
//  Created by Şimal Çubuk on 21.04.2019.
//  Copyright © 2019 Şimal Çubuk. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet weak var itemListTableView: UITableView!
    var buffer:ViewController = ViewController() // a variable to pass the entered URL to ItemListViewController
    var inputURL: String = "" // a variable to keep the url entered by the user
    var itemNameArray = [String]() // an array that contains item names as string, in order to display them in the rows
    var itemImageURLArray = [String]() // an array that contains image URLs as string, in order to get them from their corresponding URLs...
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inputURL = ViewController.url
        self.itemListTableView.dataSource = self as UITableViewDataSource
        self.itemListTableView.delegate = self as UITableViewDelegate
        
        fetchRowDataFromURL() // a function to get specific data from URL...
    }
    
    func fetchRowDataFromURL() {
        // check whether the user entered a valid URL and it is not empty...
        if(!inputURL.isEmpty && inputURL.isValid){
            let task = URLSession.shared.dataTask(with: URL(string: inputURL)!) {(data, response, error ) in
                guard let json = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? NSDictionary else {
                    print("Not containing JSON")
                    return
                }
                if let array = json.value(forKey: "results") as? NSArray {
                    // iterate over items corresponding "results": ...
                    for item in array{
                        if let itemDict = item as? NSDictionary {
                            // get value corresponds to "trackName" key
                            if let name = itemDict.value(forKey: "trackName") {
                                self.itemNameArray.append((name as? String)!)
                            }
                            // get value corresponds to "artworkUrl100" key
                            if let imageURL = itemDict.value(forKey: "artworkUrl100") {
                                self.itemImageURLArray.append((imageURL as? String)!)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.itemListTableView.reloadData()
                }
            }
            task.resume()
        } else {
            // warning message when user enters nothing or an invalid URL
            print("You must enter a valid URL...\n")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // refer to table view cell with identifier "cell"...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        // append item name as text
        cell.textLabel?.text = self.itemNameArray[indexPath.row]
        
        // get image URL
        let currentImageURL = self.itemImageURLArray[indexPath.row]
        
        // get image data
        let data = try? Data(contentsOf: URL(string: currentImageURL)!)
        // set the image of the row
        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemNameArray.count
    }
}

extension String {
    // a function to check whether or not a given URL is valid
    // this function used in fetchRowDataFromURL() method...
    var isValid: Bool {
        let dataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let dataMatch = dataDetector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return dataMatch.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
