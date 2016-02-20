# ShakeCrash-iOS
ShakeCrash is great way to involve you testers in deep in-app reporting. It's idea was taken from Google Maps, just shake your iPhone to submit screenshot with description via e-mail or Redmine!

# Installation
ShakeCrash isn't currently available on CocoaPods (I hope it will), so there is a few steps you have to perform in order to add it to your project.

#### Clone and drag

First of all, just clone the repository and drag `ShakeCrash.framework` into your project. Be sure to check **Copy items if needed**.

#### Configure framework

In order to fully connect `ShakeCrash` to your project go into your project's **General** tab and find **Embedded Binaries**. Choose option to add the new one and select **ShakeCrash.framework**.
Next, go into **Build Settings**, find **Header Search Paths** and add new entry: 
```
"$(PROJECT_DIR)/ShakeCrash.framework/Headers"
```

Good! You are done!
# Configure ShakeCrash

You have two possibilities - you can send report directly to your Redmine project issues or send it to desired e-mail address. There is no way to use both at once.
I would recommend to configure it in your `AppDelegate`. First, import `ShakeCrash`:
```
import ShakeCrash
```

#### Configure Redmine

You need to enable REST API in you Redmine and obtain your API key. Also you will need project id. You should be able to find all of them in your Redmine, in case of trouble I send you to Google.
```
let shakeReporterSettings = ShakeCrash.sharedInstance

let redmineReporter = RedmineFeedbackReporter(
redmineAddress: "<REDMINE_URL>",
apiToken: "<API_KEY>",
projectId: "<PROJECT_ID>")

shakeReporterSettings.delegate = redmineReporter
```

Correct URL has format `http(s)://www.yourredmine.com`.
**It is very important, that your Redmine version is >1.4.**

#### Configure e-mail

There are no special requirments in order to send e-mail, just configure it.
```
let shakeReporterSettings = ShakeCrash.sharedInstance

let mailReporter = MailFeedbackReporter(reportEmail: "my_email@domain.com")

shakeReporterSettings.delegate = mailReporter
```
# Configure user name

It would be very useful if you could know your tester's name. There is the way you can ask you user to enter his name and it will only trigger once. Just paste line below in your `viewDidLoad` in `UIViewController` you want your user to enter his name.
```
self.presentConfigShakeCrashView()
```
I highly recommend to use it in first view controller in your app. If you encountered some issues while calling this method make sure there are no problems with view controller's stack, because all views in `ShakeCrash` are called to present modally.