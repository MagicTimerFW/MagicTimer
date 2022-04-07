
import Foundation

extension Int {
    /// Cast Int to TimeInterval
    func convertToTimeInterval() -> TimeInterval {
        return TimeInterval(self)
    }
    /// Cast Int to String
    func convertToString() -> String {
        return String(self)
    }
  
}

extension Double {
    /// Check the number is positive(bigger than zero)
    var isPositive: Bool {
        get {
            return self>0
        }
    }
    /// Cast Double to TimeInterval
    func convertToTimeInterval() -> TimeInterval {
        
        return TimeInterval(self)
    }
}
