//  Created by Dominik Majda on 20.02.2016.
//  Copyright © 2016 Dominik Majda. All rights reserved

import UIKit

class WelcomeCrashViewController: UIViewController {

    // MARK: Outlets
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var startButton: UIButton!

    // MARK: Lifecycle
    
    // MARK: Actions

	@IBAction func nameChanged(sender: UITextField) {
		if sender.text!.count >= 3 {
			startButton.active = true
		} else {
			startButton.active = false
		}
	}

	@IBAction func startAction(sender: AnyObject) {
		ShakeCrash.sharedInstance.userName = nameTextField.text!
        self.dismiss(animated: true, completion: nil)
	}
    
    // MARK: Shake methods
    
    // We override them in order to prevent shake
    // gesture in this screen

	override func presentFeedbackView() {
		// DO NOTHING
	}

	override func presentConfigShakeCrashView() {
		// DO NOTHING
	}
}

// MARK: Text field delegate

extension WelcomeCrashViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
