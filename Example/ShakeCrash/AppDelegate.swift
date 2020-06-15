import UIKit
import ShakeCrash

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

	var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
		// Configure shake crash
		configureShakeReporter()
	}

	private func configureShakeReporter() {
	}
}
