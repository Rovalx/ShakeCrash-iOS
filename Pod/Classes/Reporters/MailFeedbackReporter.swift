import UIKit
import MessageUI

public class MailFeedbackReporter: NSObject, FeedbackReportDelegate, MFMailComposeViewControllerDelegate {

	public var bugReportAddress: String

	public init(reportEmail: String) {
		self.bugReportAddress = reportEmail
	}

	public func sendReportFromViewController(
		activeScreenName: String,
		callingViewController: UIViewController,
		image: UIImage,
		description: String,
		userName: String) {

			let mailComposeViewController = configuredMailComposeViewController(
				activeScreenName,
				image: image,
				description: description,
				userName: userName)

			if MFMailComposeViewController.canSendMail() {

				callingViewController.presentedViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in

					callingViewController.presentViewController(mailComposeViewController, animated: true, completion: nil)
				})
			}
	}

	internal func configuredMailComposeViewController(
		activeScreenName: String,
		image: UIImage,
		description: String,
		userName: String) -> MFMailComposeViewController {

			// Create image attachment
			let jpegData = UIImageJPEGRepresentation(image, 1.0);
			var fileName: NSString = "raport";
			fileName = fileName.stringByAppendingPathExtension(".jpeg")!

			// Create email
			let mailComposerVC = MFMailComposeViewController()
			mailComposerVC.mailComposeDelegate = self
			mailComposerVC.setToRecipients([bugReportAddress])

			var title = "[ShakeReporter"
			if let userName = ShakeCrash.sharedInstance.userName {
				title += "] Report from \(userName)"
			} else {
				title += "] Report"
			}
			let versioNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!
			let appBuildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion")!
			title += ", \(activeScreenName), version \(versioNumber)(\(appBuildNumber))"
			mailComposerVC.setSubject(title)

			mailComposerVC.addAttachmentData(jpegData!,
				mimeType: "image/jpeg",
				fileName: fileName as String)

			mailComposerVC.setMessageBody(
				"<html><body><p>\(userName)</p></br> "
					+ "<p>\(description)</p></body></html>",
				isHTML: true)

			return mailComposerVC
	}

	public func mailComposeController(controller: MFMailComposeViewController,
		didFinishWithResult result: MFMailComposeResult, error: NSError?) {

			controller.dismissViewControllerAnimated(true, completion: nil)
	}
}