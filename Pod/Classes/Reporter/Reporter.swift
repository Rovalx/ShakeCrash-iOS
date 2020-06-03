import AVFoundation
import Foundation

internal final class Reporter {
    
    static func send(report: Report, completion: @escaping (Bool, Error?) -> ()) {
        let formatter = ISO8601DateFormatter()
        
        guard let appKey = ShakeCrash.appKey else {
            print("Missing appKey, you need to initialize ShakeCrash first")
            return
        }
        
        let params: [String: Any?] = [
            "appKey": appKey,
            "screenName": report.screenName,
            "screenshot":
                report.screenshot.resizeImage(newWidth: 800)?.jpegData(compressionQuality: 99)?.base64EncodedString(),
            "text": report.text,
            "identity": ShakeCrash.userId,
            "attribiutes": ShakeCrash.userAttribiutes,
            "deviceAttribiutes": deviceAttribiutes(),
//            "logs": ShakeCrash.log.entries,
            "date": formatter.string(from: Date())
        ]
        
        let url = URL(string: "your path")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            completion(false, error)
            return
        }
        
        request.addValue("your key", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("your key", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
        })
        task.resume()
    }

    
    private static func deviceAttribiutes() -> Attribiutes {
        var details = [String: String]()
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        var osVersionStr = String(osVersion.majorVersion)
        osVersionStr += "." + String(osVersion.minorVersion)
        osVersionStr += "." + String(osVersion.patchVersion)
        details["os"] = "iOS"
        details["deviceBrand"] = "iPhone"
        details["osVersion"] = osVersionStr
        details["package"] = Bundle.main.bundleIdentifier
        details["hostName"] = ProcessInfo.processInfo.hostName
        details["deviceModel"] = UIDevice.current.modelName
        details["deviceUuid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        details["screenOrientation"] = screenOrientation()
        details["screenWidth"] = "\(UIScreen.main.bounds.width)"
        details["screenHeight"] = "\(UIScreen.main.bounds.height)"
        details["soundLevel"] = "\(AVAudioSession.sharedInstance().outputVolume)"
        details["timezone"] = NSTimeZone.local.identifier
        details["region"] = NSLocale.current.regionCode
        details["networkMode"] = "wifi" // TODO!!
        details["batteryLevel"] = "\(UIDevice.current.batteryLevel)"
        details["appVersion"] = Bundle.main.infoVersionNumber
        return details
    }
    
    // android: SDK, Release?, device? app versi, tablet
    // inaczej release/incremental, country
    
    
    //{,"Device":"addison","Product":"addison","SDK":"26","Release":"8.0.0","Incremental":"10",,"Tablet":false,"Screen_Layout":"Normal Screen","Country":"Polska",}
    
    private static func screenOrientation() -> String {
        switch UIDevice.current.orientation{
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .landscapeLeft:
            return "landscapeLeft"
        case .landscapeRight:
            return "landscapeRight"
        default:
            return "another"
        }
    }
}
