import Foundation

public class ShakeCrash {

	internal let USER_NAME = "user_name"
	internal let SETTINGS = "shaker_settings"

	public static let sharedInstance = ShakeCrash()

	public var delegate: FeedbackReportDelegate?

	public var projectName: String?

	public var userName: String? {

		get {
            let settings = UserDefaults(suiteName: SETTINGS)
            return settings?.string(forKey: USER_NAME)
		}

		set {
            let settings = UserDefaults(suiteName: SETTINGS)
            settings?.set(newValue, forKey: USER_NAME)
			settings?.synchronize()
		}
	}
}
