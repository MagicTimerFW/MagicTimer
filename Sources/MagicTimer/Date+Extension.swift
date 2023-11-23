import Foundation

public extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate.minus(rhs.timeIntervalSinceReferenceDate)
    }
}
