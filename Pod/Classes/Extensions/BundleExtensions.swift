import Foundation

internal extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
    
    var infoVersionNumber: String {
        "\(releaseVersionNumber ?? "0.0.0") (\(buildVersionNumber ?? "0"))"
    }
}
