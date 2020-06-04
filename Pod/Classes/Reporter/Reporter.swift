import AVFoundation
import Foundation

internal final class Reporter {
    
    class ReporterError: LocalizedError {
        let msg: String
        init(_ msg: String) {
            self.msg = msg
        }
        
        var localizedDescription: String {
            return msg
        }
    }
    
    static func send(report: Report, completion: @escaping (Bool, Error?) -> ()) {
        let formatter = ISO8601DateFormatter()
        let config = ShakeCrash.reporterConfig!
        
        guard let appKey = ShakeCrash.appKey else {
            print("Missing appKey, you need to initialize ShakeCrash first")
            return
        }
        
        let params: [String: Any?] = [
            "appKey": appKey,
            "screenName": report.screenName,
            "text": report.text,
            "identity": ShakeCrash.userId,
            "attribiutes": ShakeCrash.userAttribiutes,
            "deviceAttribiutes": deviceAttribiutes(),
            "type": report.type.rawValue,
            "logs": logsToDict(logs: ShakeCrash.log.entries),
            "date": formatter.string(from: Date())
        ]
        
        let url = config.url
        let session = URLSession.shared
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        for (key, value) in config.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        var multiParams = [[String: Any]]()
        for (key, value) in params where value != nil {
            if value is [String: Any] || value is [[String: Any]] {
                do {
                    let jsonData = try JSONSerialization.data(
                        withJSONObject: value!, options: .prettyPrinted)
                    multiParams.append(
                        ["name": key, "value": String(data: jsonData, encoding: .utf8)!]
                    )
                } catch let error {
                    print("Unable to serialize \(key), \(error.localizedDescription)")
                }
            } else {
                multiParams.append(
                    ["name": key, "value": "\(value!)"]
                )
            }
        }
        multiParams.append(
            ["name": "screenshot", "file": report.screenshot.jpegData(compressionQuality: 90)!]
        )
        
        urlRequest.setPost(body: multiParams)
        
        // Send a POST request to the URL, with the data we created earlier
        let task = session.dataTask(with: urlRequest) { responseData, response, error in
            
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
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if statusCode != 201 {
                    completion(false, ReporterError("Incorrect status code: \(statusCode ?? -1)"))
                    return
                }
                
                completion(true, nil)
            }
            
        }
        task.resume()
    }
    
    private static func deviceAttribiutes() -> Attribiutes {
        var details = [String: String]()
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        var osVersionStr = String(osVersion.majorVersion)
        osVersionStr += "." + String(osVersion.minorVersion)
        osVersionStr += "." + String(osVersion.patchVersion)
        details["os"] = "iOS"
        details["deviceBrand"] = "Apple"
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
        details["local"] = "\(NSLocale.current)"
        details["networkMode"] = "wifi" // TODO!!
        details["batteryLevel"] = "\(UIDevice.current.batteryLevel)"
        details["appVersion"] = Bundle.main.infoVersionNumber
        return details
    }
    
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
    
    private static func logsToDict(logs: [Log.Entry]) -> [[String: String]] {
        let formatter = ISO8601DateFormatter()
        return logs.map { (entry) -> [String: String] in
            return [
                "level": entry.level.rawValue,
                "text": entry.text,
                "date": formatter.string(from: entry.time)
            ]
        }
    }
}
