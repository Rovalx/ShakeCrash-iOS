//
//  ViewController.swift
//  ShakeCrash
//
//  Created by Dominik Majda on 03/19/2016.
//  Copyright (c) 2016 Dominik Majda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func alertAction(_ sender: Any) {
        let alert = UIAlertController(title: "test", message: "test", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

