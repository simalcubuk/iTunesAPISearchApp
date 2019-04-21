//
//  ViewController.swift
//  DolapProject
//
//  Created by Şimal Çubuk on 20.04.2019.
//  Copyright © 2019 Şimal Çubuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var userInputButton: UIButton!
    static var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func enterURLAction(_ sender: Any) {
        ViewController.url = userInputTextField.text!
    }
}

