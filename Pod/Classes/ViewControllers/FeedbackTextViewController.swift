//
//  FeedbackTextViewController.swift
//  Pods-ShakeCrash_Example
//
//  Created by Dominik Majda on 01/06/2020.
//

import UIKit

protocol FeedbackTextDelegate: class {
    func didChangeText(_ text: String)
}

class FeedbackTextViewController: UIViewController, UITextViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    
    var currentText: String!
    weak var delegate: FeedbackTextDelegate?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = currentText
        descriptionTextView.becomeFirstResponder()
    }

    // MARK: Text view delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // End editing
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangeText(textView.text)
    }
}
