import Foundation
import MathOperators

public protocol MagicTimerCounterInterface {
    /// The total counted value.
    var totalCountedValue: TimeInterval { get set }
    /// A number which is added or minused on each ``timeInterval``.
    var effectiveValue: TimeInterval { get set }
    /// The initial value of counter.
    var defultValue: TimeInterval { get set }
    /// Add effectiveValue to totalCountedValue.
    func add()
    /// Subtract effectiveValue from totalCountedValue.
    func subtract()
    /// Reset totalCountedValue to zero.
    func resetTotalCounted()
    /// Reset totalCountedValue to defultValue.
    func resetToDefaultValue()
}

public final class MagicTimerCounter: MagicTimerCounterInterface {
    
    // MARK: - Public properties
    public var totalCountedValue: TimeInterval = 0
    public var effectiveValue: TimeInterval = 1.0
    public var defultValue: TimeInterval = 0.0 {
        didSet {
            totalCountedValue = totalCountedValue.plus(defultValue)
        }
    }
    
    // MARK: - Constructors
    public init() { }
    
    // MARK: - Public methods
    public func add() {
        totalCountedValue = totalCountedValue.plus(effectiveValue)
    }
    
    public func subtract() {
        totalCountedValue = totalCountedValue.minus(effectiveValue)
    }
    
    public func resetTotalCounted() {
        totalCountedValue = 0
    }
    
    public func resetToDefaultValue() {
        totalCountedValue = defultValue
    }
}

