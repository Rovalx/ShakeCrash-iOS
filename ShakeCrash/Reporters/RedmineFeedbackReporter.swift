import UIKit

public class RedmineFeedbackReporter: NSObject, FeedbackReportDelegate {

	public var redmineAddress: String
	public var apiToken: String
	public var projectId: String

	public init(redmineAddress: String, apiToken: String, projectId: String) {
		self.redmineAddress = redmineAddress
		self.apiToken = apiToken
		self.projectId = projectId
	}

	public func sendReportFromViewController(
		viewController: UIViewController,
		image: UIImage,
		description: String,
		userName: String) {

			// Start network indicator and deactivate button
			if let feedbacVC = viewController.presentedViewController
			as? FeedabackViewController {
				feedbacVC.sendButton.active = false
			}
			UIApplication.sharedApplication().networkActivityIndicatorVisible = true

			sendImageToRedMine(viewController, image: image, description: description, userName: userName)
	}

	private func sendIssueToRedmine(
		viewController: UIViewController,
		description: String,
		userName: String,
		token: String) {

			// Create POST request body
			let request = NSMutableURLRequest(URL: NSURL(string: "\(redmineAddress)/projects/\(projectId)/issues.json")!)
			request.HTTPMethod = "POST"
			request.addValue(apiToken, forHTTPHeaderField: "X-Redmine-API-Key")
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")

			var title = "[ShakeReporter"
			if let userName = ShakeCrash.sharedInstance.userName {
				title += "] Report from \(userName)"
			} else {
				title += "] Report"
			}
			let versioNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!
			let appBuildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion")!
			title += " ,version \(versioNumber)(\(appBuildNumber))"

			let params = [
				"issue": [
					"subject": title,
					"priority": "4",
					"description" : description,
					"uploads" : [
						[
							"token" : token,
							"filename" : "report_\(NSDate().timeIntervalSince1970).jpeg",
							"content_type" : "image/jpeg"
						]
					]
				]
			]
			do {
				let json = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
				request.HTTPBody = json
			} catch {
				print("Redmine Reporter: crashed while creating parameters")
				self.showErrorMessage(viewController.presentedViewController,
					message: "Can't understand issue response")
				return
			}

			// Send it
			let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in

				guard error == nil && data != nil else {
					print("Redmine Reporter: error = \(error) ")
					self.showErrorMessage(viewController.presentedViewController,
						message: "Error while sending issue")
					return
				}

				if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 201 {
					print("Redmine Reporter: statusCode should be 200, but is \(httpStatus.statusCode) ")
					print("Redmine Reporter: response = \(response) ")
					self.showErrorMessage(viewController.presentedViewController,
						message: "Issue couldn't be added")
				}

				// Hide network indicator on success
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
				viewController.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
			}
			task.resume()
	}

	private func sendImageToRedMine(
		viewController: UIViewController,
		image: UIImage,
		description: String,
		userName: String) {

			// Create POST request body
			let request = NSMutableURLRequest(URL: NSURL(string: "\(redmineAddress)/uploads.json")!)
			request.HTTPMethod = "POST"
			request.addValue(apiToken, forHTTPHeaderField: "X-Redmine-API-Key")
			request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
			request.HTTPBody = UIImageJPEGRepresentation(image, 1.0)

			// Send it
			let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in

				guard error == nil && data != nil else {
					print("Redmine Reporter: error = \(error) ")
					self.showErrorMessage(viewController.presentedViewController,
						message: "Error while sending attachment")
					return
				}

				if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 201 {
					print("Redmine Reporter: statusCode should be 200, but is \(httpStatus.statusCode) ")
					print("Redmine Reporter: response = \(response) ")
					self.showErrorMessage(viewController.presentedViewController,
						message: "Attachment couldn't be added")
				}

				do {
					if let data = data {
						let responseJSON = try NSJSONSerialization.JSONObjectWithData(
							data, options: NSJSONReadingOptions.MutableContainers)

						if let upload = responseJSON["upload"], let token = upload?["token"] as? String {
							self.sendIssueToRedmine(viewController, description: description, userName: userName, token: token)
						} else {
							print("Redmine Reporter: no photo token in response")
							self.showErrorMessage(viewController.presentedViewController,
								message: "No photo attachment in response")
						}
					} else {
						print("Redmine Reporter: no photo data in response")
						self.showErrorMessage(viewController.presentedViewController,
							message: "No data in attachment response")
					}
				} catch {
					print("Redmine Reporter: crashed while deserializing")
					self.showErrorMessage(viewController.presentedViewController,
						message: "Can't understand attachment response")
				}
			}
			task.resume()
	}

	private func showErrorMessage(viewController: UIViewController?, message: String) {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.showAlertWithTitle("Issue couldn't be send", message: message, viewController: viewController)
		}
	}

	private func showAlertWithTitle(title: String, message: String, viewController: UIViewController?) {

		UIApplication.sharedApplication().networkActivityIndicatorVisible = false

		if let viewController = viewController {

			// Hide network indicator on error and activate button
			if let feedbacVC = viewController as? FeedabackViewController {
				feedbacVC.sendButton.active = true
			}

			// Show allert
			let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
			viewController.presentViewController(alert, animated: true, completion: nil)
		}
	}
}