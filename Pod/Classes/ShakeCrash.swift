import Foundation

public final class ShakeCrash {

    internal static var appKey: String!
    
    internal static var userAttribiutes = [String: Any]()
    internal static var userId: String?
    
    public static let log = Log()

	public var delegate: FeedbackReportDelegate?
    
    private init() {}
    
    // MARK: Start crash
    
    public static func initialize(withAppKey key: String) {
        appKey = key
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
        
        enum Level {
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
