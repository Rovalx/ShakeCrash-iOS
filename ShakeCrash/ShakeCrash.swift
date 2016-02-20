import Foundation

public class ShakeCrash {

	internal let USER_NAME = "user_name"
	internal let SETTINGS = "shaker_settings"

	public static let sharedInstance = ShakeCrash()

	public var delegate: FeedbackReportDelegate?

	public var projectName: String?

	public var userName: String? {

		get {
			let settings = NSUserDefaults(suiteName: SETTINGS)
			return settings?.stringForKey(USER_NAME)
		}

		set {
			let settings = NSUserDefaults(suiteName: SETTINGS)
			settings?.setObject(newValue, forKey: USER_NAME)
			settings?.synchronize()
		}
	}
}