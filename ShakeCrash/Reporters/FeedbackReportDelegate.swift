import UIKit

public protocol FeedbackReportDelegate: class {
	func sendReportFromViewController(
		activeScreenName: String,
		callingViewController: UIViewController,
		image: UIImage,
		description: String,
		userName: String)
}