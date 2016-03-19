import UIKit

extension UIViewController {

	func listAllConstraints() {
		for subview in view.subviews as [UIView] {
			for constraint in subview.constraints as [NSLayoutConstraint] {
				print(constraint)
			}
		}
	}

	public override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
		if motion == .MotionShake {
			if ShakeCrash.sharedInstance.userName == nil {
				presentConfigShakeCrashView()
			} else {
				presentFeedbackView()
			}
		}
	}

	public func presentFeedbackView() {

		let viewController = currentViewController()

		// Create feedback view controller
		let feedbackVC = FeedabackViewController(
			nibName: "FeedabackViewController",
			bundle: NSBundle(forClass: FeedabackViewController.self))
		let image = capture()
		feedbackVC.image = image
		feedbackVC.callingViewController = viewController
		feedbackVC.viewControllerName = "\(self.dynamicType)"

		feedbackVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		feedbackVC.modalPresentationStyle = .OverCurrentContext

		// Present feedback view controller
		viewController?.presentViewController(feedbackVC, animated: true, completion: nil)
	}

	public func presentConfigShakeCrashView() {

		if ShakeCrash.sharedInstance.userName == nil {

			let viewController = currentViewController()

			// Create feedback view controller
			let welcomeVC = WelcomeCrashViewController(
				nibName: "WelcomeCrashViewController",
				bundle: NSBundle(forClass: WelcomeCrashViewController.self))

			welcomeVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
			welcomeVC.modalPresentationStyle = .OverCurrentContext

			// Present feedback view controller
			viewController?.presentViewController(welcomeVC, animated: true, completion: nil)
		}
	}

	private func currentViewController() -> UIViewController? {

		// Get current view controller
		var viewController = UIApplication.sharedApplication().keyWindow?.rootViewController

		if let presentedViewController = viewController?.presentedViewController {
			viewController = presentedViewController
		}

		return viewController
	}

	private func capture() -> UIImage {

		let masterView = UIApplication.sharedApplication().keyWindow!
		let scale = UIScreen.mainScreen().scale

		UIGraphicsBeginImageContextWithOptions(
			masterView.frame.size, masterView.opaque, scale)
		masterView.drawViewHierarchyInRect(
			masterView.bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}
}