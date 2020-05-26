import UIKit
import ShakeCrash

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

	var window: UIWindow?

    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		// Override point for customization after application launch.
		let splitViewController = self.window!.rootViewController as! UISplitViewController
		let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count - 1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		splitViewController.delegate = self

		// Configure shake crash
		configureShakeReporter()

		return true
	}

	private func configureShakeReporter() {
		let shakeReporterSettings = ShakeCrash.sharedInstance
//
//		let redmineReporter = RedmineFeedbackReporter(
//			redmineAddress: "redmineaddress",
//			apiToken: "apitoken",
//			projectId: "projectid")

//		shakeReporterSettings.delegate = redmineReporter
	}

	// MARK: - Split view

	func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
		guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
		guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
		if topAsDetailController.detailItem == nil {
			// Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
			return true
		}
		return false
	}
}
