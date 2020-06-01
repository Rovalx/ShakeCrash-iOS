import Foundation

extension String {
    internal var nilIfEmpty: String? {
        if self.isEmpty {
            return nil
        }
        return self
    }
}
