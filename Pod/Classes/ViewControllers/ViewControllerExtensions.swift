import UIKit

extension UIViewController {
    
    // MARK: Detect shaking
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
			if ShakeCrash.sharedInstance.userName == nil {
				presentConfigShakeCrashView()
			} else {
				presentFeedbackView()
			}
		}
	}
    
    // MARK: Present screenshot
    
    // TODO: Check what is going on here

	@objc public func presentFeedbackView() {

		let viewController = currentViewController()

		// Create feedback view controller
		let feedbackVC = FeedabackViewController(
			nibName: "FeedabackViewController",
            bundle: Bundle(for: FeedabackViewController.self))
        let image = capture()
		feedbackVC.image = image
		feedbackVC.callingViewController = viewController
        feedbackVC.viewControllerName = "\(type(of: self))"

        feedbackVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        feedbackVC.modalPresentationStyle = .overCurrentContext

		// Present feedback view controller
        viewController?.present(feedbackVC, animated: true, completion: nil)
	}

    @objc public func presentConfigShakeCrashView() {

		if ShakeCrash.sharedInstance.userName == nil {

			let viewController = currentViewController()

			// Create feedback view controller
			let welcomeVC = WelcomeCrashViewController(
				nibName: "WelcomeCrashViewController",
                bundle: Bundle(for: WelcomeCrashViewController.self))

            welcomeVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            welcomeVC.modalPresentationStyle = .overCurrentContext

			// Present feedback view controller
            viewController?.present(welcomeVC, animated: true, completion: nil)
		}
	}
    
    // MARK: Find top controller
    
    // TODO: This is incorrect!@

	private func currentViewController() -> UIViewController? {

		// Get current view controller
        var viewController = UIApplication.shared.keyWindow?.rootViewController

		if let presentedViewController = viewController?.presentedViewController {
			viewController = presentedViewController
		}

		return viewController
	}
    
    // MARK: Capture screenshot

    // TODO: This is outdated as fuck
    
	private func capture() -> UIImage {

        let masterView = UIApplication.shared.keyWindow!
        let scale = UIScreen.main.scale

		UIGraphicsBeginImageContextWithOptions(
            masterView.frame.size, masterView.isOpaque, scale)
        masterView.drawHierarchy(
            in: masterView.bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}
}
