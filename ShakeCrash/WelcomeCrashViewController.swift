//
//  WelcomeViewController.swift
//  ShakeCrash
//
//  Created by Dominik Majda on 20.02.2016.
//  Copyright © 2016 MajduMajdu. All rights reserved.
//

import UIKit

class WelcomeCrashViewController: UIViewController {

	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var startButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func nameChanged(sender: UITextField) {

		if sender.text?.characters.count >= 3 {
			startButton.active = true
		} else {
			startButton.active = false
		}
	}

	@IBAction func startAction(sender: AnyObject) {
		ShakeCrash.sharedInstance.userName = nameTextField.text!
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	override func presentFeedbackView() {
		// DO NOTHING
	}
}

extension WelcomeCrashViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}