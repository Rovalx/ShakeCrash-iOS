import UIKit

public protocol FeedbackReportDelegate: class {
	func sendReportFromViewController(
		viewController: UIViewController,
		image: UIImage,
		description: String,
		userName: String)
}