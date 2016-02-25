import UIKit
import MessageUI

class FeedabackViewController: UIViewController, MFMailComposeViewControllerDelegate {

	@IBOutlet weak var blueButton: UIButton!
	@IBOutlet weak var redButton: UIButton!
	@IBOutlet weak var greenButton: UIButton!

	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var drawableView: DrawableView!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var feedbackImageView: UIImageView!
	@IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

	var image: UIImage?
	var callingViewController: UIViewController?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Set image in image view
		feedbackImageView.image = image

		// Opacity for view
		view.backgroundColor = UIColor.clearColor()
		view.opaque = false
	}

	// MARK: - Outlet Actions

	@IBAction func sendAction(sender: AnyObject) {
		if let callingViewController = callingViewController,
		description = descriptionTextView.text,
		userName = ShakeCrash.sharedInstance.userName {

			ShakeCrash.sharedInstance.delegate?
				.sendReportFromViewController(
					callingViewController,
					image: captureContentView(),
					description: description,
					userName: userName)
		}
    }

	@IBAction func dissmissAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func changeColorAction(sender: UIButton) {

		switch sender {
		case redButton:
			drawableView.strokeColor = UIColor.redColor()
		case blueButton:
			drawableView.strokeColor = UIColor.blueColor()
		case greenButton:
			drawableView.strokeColor = UIColor.greenColor()
		default:
			drawableView.strokeColor = UIColor.redColor()
		}
	}

	override func presentFeedbackView() {
		// DO NOTHING
	}
    
    override func presentConfigShakeCrashView() {
        // DO NOTHING
    }

	func captureContentView() -> UIImage {

		UIGraphicsBeginImageContextWithOptions(contentView.frame.size, true, UIScreen.mainScreen().scale)
		drawableView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		contentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}
}

extension FeedabackViewController: UITextViewDelegate {

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)

		// End editing
		self.view.endEditing(true)
	}

	func textViewDidBeginEditing(textView: UITextView) {
		self.textViewHeightConstraint.constant = 200.0
	}

	func textViewDidEndEditing(textView: UITextView) {
		self.textViewHeightConstraint.constant = 50.0
	}
}
