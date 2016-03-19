# ShakeCrash

ShakeCrash is great way to involve you testers in deep in-app reporting. It's idea was taken from Google Maps, just shake your iPhone to submit screenshot with description via e-mail or Redmine!

[![CI Status](http://img.shields.io/travis/Dominik Majda/ShakeCrash.svg?style=flat)](https://travis-ci.org/Dominik Majda/ShakeCrash)
[![Version](https://img.shields.io/cocoapods/v/ShakeCrash.svg?style=flat)](http://cocoapods.org/pods/ShakeCrash)
[![License](https://img.shields.io/cocoapods/l/ShakeCrash.svg?style=flat)](http://cocoapods.org/pods/ShakeCrash)
[![Platform](https://img.shields.io/cocoapods/p/ShakeCrash.svg?style=flat)](http://cocoapods.org/pods/ShakeCrash)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ShakeCrash is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ShakeCrash"
```

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

It would be very useful if you could know your tester's name. There is the way you can ask your user to enter his name and it will only trigger once. Just paste line below in your `viewDidLoad` in `UIViewController` you want your user to enter his name.
```
self.presentConfigShakeCrashView()
```

If you don't do it, the first time user will make shake gesture ShakeCrash will ask for name. But it is up to you to inform user that there is shake gesture in app.

I highly recommend to use it in first view controller in your app. If you encountered some issues while calling this method make sure there are no problems with view controller's stack, because all views in `ShakeCrash` are called to present modally.

## Author

Dominik Majda, ddmajda@gmail.com

## License

ShakeCrash is available under the MIT license. See the LICENSE file for more info.

