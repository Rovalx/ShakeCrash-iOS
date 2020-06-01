import UIKit

extension UIViewController {
    
    // MARK: Detect shaking
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            presentFeedbackView()
		}
	}
    
    // MARK: Present screenshot
    
    // TODO: Check what is going on here

	@objc public func presentFeedbackView() {

        let navVC = UINavigationController()
        navVC.navigationBar.barTintColor = .white
        
		let viewController = currentViewController()

		// Create feedback view controller
		let feedbackVC = FeedbackViewController(
			nibName: "FeedbackViewController",
            bundle: Bundle(for: FeedbackViewController.self))
        let image = capture()
		feedbackVC.image = image
		feedbackVC.callingViewController = viewController
        feedbackVC.viewControllerName = "\(type(of: self))"
        
        navVC.viewControllers = [feedbackVC, ]
        navVC.modalPresentationStyle = .fullScreen
        
		// Present feedback view controller
        viewController?.present(navVC, animated: true, completion: nil)
	}
    
    // MARK: Find top controller

	private func currentViewController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        
        return topController
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
