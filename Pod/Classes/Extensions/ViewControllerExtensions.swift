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
        
        let viewController = currentViewController()
        let alert = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
        
        func present(reportType: Report.FeedbackType) {
            alert.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                
                let navVC = UINavigationController()
                navVC.navigationBar.barTintColor = .white
                
                // Create feedback view controller
                let feedbackVC = FeedbackViewController(
                    nibName: "FeedbackViewController",
                    bundle: Bundle(for: FeedbackViewController.self))
                let image = self.capture()
                feedbackVC.image = image
                feedbackVC.reportType = reportType
                feedbackVC.callingViewController = viewController
                feedbackVC.viewControllerName = "\(type(of: self))"
                
                navVC.viewControllers = [feedbackVC, ]
                navVC.modalPresentationStyle = .fullScreen
                
                // Present feedback view controller
                viewController?.present(navVC, animated: true, completion: nil)
            }
        }
        
        alert.addAction(UIAlertAction(title: "Report a problem", style: .default, handler: { (alert) in
            present(reportType: .problem)
        }))
        alert.addAction(UIAlertAction(title: "Suggest a change", style: .default, handler: { (alert) in
            present(reportType: .suggestion)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
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
