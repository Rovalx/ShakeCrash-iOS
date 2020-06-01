import UIKit
import MessageUI

internal final class FeedbackViewController: UIViewController, FeedbackTextDelegate {

    // MARK: Outlets
    
	@IBOutlet weak var blueButton: UIButton!
	@IBOutlet weak var redButton: UIButton!
	@IBOutlet weak var greenButton: UIButton!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var drawableView: DrawableView!
	@IBOutlet weak var descriptionTextView: UILabel!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var feedbackImageView: UIImageView!

    // MARK: Properties
    
    var saveButton: UIBarButtonItem!
	var image: UIImage!
	var viewControllerName: String!
	var callingViewController: UIViewController!
    
    // MARK: Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()

		// Set image in image view
		feedbackImageView.image = image
        
        // Setup navigation bar
        title = "Report crash"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel", style: .plain,
            target: self, action: #selector(dissmissAction(sender:))
        )
        saveButton = UIBarButtonItem(
            title: "Save", style: .done,
            target: self, action: #selector(sendAction(sender:))
        )
        navigationItem.rightBarButtonItem = saveButton
        
        // Add tap gesture to label
        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(textChangeAction(sender:))
        )
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.addGestureRecognizer(tapGesture)
	}

	// MARK: Actions

	@objc private func sendAction(sender: UIBarButtonItem) {
        Reporter.send(report: Report(
            screenName: viewControllerName,
            callingViewController:
            callingViewController,
            screenshot: captureContentView(),
            text: descriptionTextView.text?.nilIfEmpty)
        )
	}

	@objc private func dissmissAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
	}
    
    @objc private func textChangeAction(sender: UITapGestureRecognizer) {
        // Create feedback view controller
        let feedbackTextVC = FeedbackTextViewController(
            nibName: "FeedbackTextViewController",
            bundle: Bundle(for: FeedbackTextViewController.self))
        feedbackTextVC.delegate = self
        if descriptionTextView.textColor != .lightGray {
            feedbackTextVC.currentText = descriptionTextView.text ?? ""
        }
        
        navigationController?.pushViewController(feedbackTextVC, animated: true)
    }

	@IBAction func changeColorAction(sender: UIButton) {

		switch sender {
		case redButton:
            drawableView.strokeColor = .red
		case blueButton:
            drawableView.strokeColor = .blue
		case greenButton:
            drawableView.strokeColor = .green
		default:
            drawableView.strokeColor = .red
		}
	}
    
    
    // MARK: Shake methods
    
    // We override them in order to prevent shake
    // gesture in this screen

	override func presentFeedbackView() {
		// DO NOTHING
	}
    
    // MARK: Capture screenshot
    
    // TODO: This is outdated as fuck

	func captureContentView() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(contentView.frame.size, true, UIScreen.main.scale)
        drawableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}

    // MARK: Text view delegate
    
    func didChangeText(_ text: String) {
        descriptionTextView.textColor = text.isEmpty ? .lightGray : .black
        descriptionTextView.text = text
    }
    
}
