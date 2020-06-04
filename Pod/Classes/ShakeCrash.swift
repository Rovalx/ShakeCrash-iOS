import Foundation

public typealias Attribiutes = [String: Any]

public final class ShakeCrash {
    
    public struct Config {
        let url: URL
        let headers: [String: String]
        
        public init(url: URL, headers: [String: String]) {
            self.url = url
            self.headers = headers
        }
    }

    internal static var appKey: String!
    
    internal static var userAttribiutes = Attribiutes()
    internal static var userId: String?
    
    internal static var reporterConfig: Config!
    
    public static let log = Log()
    
    private init() {}
    
    // MARK: Start crash
    
    public static func initialize(withAppKey key: String, config: Config) {
        appKey = key
        reporterConfig = config
    }

    // MARK: User attribiutes
    
    public static func insert(attribiute key: String, value: String) {
        userAttribiutes[key] = value
    }
    
    public static func remove(attribiute key: String) {
        userAttribiutes.removeValue(forKey: key)
    }
    
    public static func removeAllAttribiutes() {
        userAttribiutes.removeAll()
    }
    
    public static func setUserIdentity(_ identity: String) {
        userId = identity
    }
    
    public static func removeUserIdentity() {
        userId = nil
    }
}

public final class Log {
    
    internal struct Entry {
        
        enum Level: String {
            case verbose, debug, info, warning, error
        }
        
        let level: Level
        let text: String
        let time: Date
        
        init(level: Level, text: String) {
            self.level = level
            self.text = text
            self.time = Date()
        }
    }
    
    internal var entries = [Entry]()
    
    public func verbose(_ str: String) {
        entries.append(Entry(level: .verbose, text: str))
    }
    
    public func debug(_ str: String) {
        entries.append(Entry(level: .debug, text: str))
    }
    
    public func info(_ str: String) {
        entries.append(Entry(level: .info, text: str))
    }
    
    public func warning(_ str: String) {
        entries.append(Entry(level: .warning, text: str))
    }
    
    public func error(_ str: String) {
        entries.append(Entry(level: .error, text: str))
    }
}

internal struct Report {
    enum FeedbackType: String {
        case problem, suggestion
    }
    
    let screenName: String
    let callingViewController: UIViewController
    let screenshot: UIImage
    let text: String?
    let type: FeedbackType
}
