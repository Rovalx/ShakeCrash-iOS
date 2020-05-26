import UIKit
import MessageUI

class FeedabackViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // MARK: Outlets
    
	@IBOutlet weak var blueButton: UIButton!
	@IBOutlet weak var redButton: UIButton!
	@IBOutlet weak var greenButton: UIButton!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var drawableView: DrawableView!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var feedbackImageView: UIImageView!
	@IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: Properties
    
	var image: UIImage!
	var viewControllerName: String!
	var callingViewController: UIViewController!
    
    // MARK: Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()

		// Set image in image view
		feedbackImageView.image = image

		// Opacity for view
        view.backgroundColor = .clear
        view.isOpaque = false
	}

	// MARK: Actions

	@IBAction func sendAction(sender: AnyObject) {
		guard
			let description = descriptionTextView.text,
			let userName = ShakeCrash.sharedInstance.userName else {
                return
        }

        ShakeCrash.sharedInstance.delegate?
            .sendReportFromViewController(
                activeScreenName: viewControllerName,
                callingViewController: callingViewController,
                image: captureContentView(),
                description: description,
                userName: userName)
	}

	@IBAction func dissmissAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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

    override func presentConfigShakeCrashView() {
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
}

// MARK: Text view delegate

extension FeedabackViewController: UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

		// End editing
		self.view.endEditing(true)
	}
    
    func textViewDidBeginEditing(_ textView: UITextView) {
		self.textViewHeightConstraint.constant = 200.0
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		self.textViewHeightConstraint.constant = 50.0
	}
}
