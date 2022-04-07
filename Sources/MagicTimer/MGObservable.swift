
import Foundation

/// A type that can observe a closure.
protocol MGObservableBehavior {
    var observeValue: (() -> Void)? { get set }
}
/// A type that can observe time interval in closure.
protocol MGObservebaleTimeInterval {
    var observe: ((TimeInterval) -> Void)? { get set }

}
