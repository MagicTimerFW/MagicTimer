
import Foundation

/// A type that represent counter behavior
protocol MGCounterBehavior {
    /// The total counted vlaue
    var totalCountedValue: TimeInterval { get }
    /// The value that affect to totalCountedValue
    var effectiveValue: TimeInterval { get }
    /// The initial value of counter
    var defultValue: TimeInterval { get }
    /// Add effectiveValue to totalCountedValue
    func add()
    /// Subtract effectiveValue from totalCountedValue
    func subtract()
    /// Reset totalCountedValue to zero
    func resetTotalCounted()
    /// Set Value to totalCountedValue
    func setTotalCountedValue(_ value: TimeInterval)
    /// Set value to effectiveValue
    func setEffectiveValue(_ value: TimeInterval)
    /// Set value to defultValue
    func setDefaultValue(_ value: TimeInterval)
    /// Reset totalCountedValue to defultValue
    func resetToDefaultValue()
}

class MGCounter: MGCounterBehavior, MGLogable {
    
    var totalCountedValue: TimeInterval = 0
    var effectiveValue: TimeInterval = 1.0
    var defultValue: TimeInterval = 0.0 {
        willSet {
            totalCountedValue += newValue
        }
    }
    
    func add() {
        totalCountedValue += effectiveValue
    }
    
    func subtract() {
        totalCountedValue -= effectiveValue
    }
    
    func resetTotalCounted() {
        totalCountedValue = 0
    }
    
    func setTotalCountedValue(_ value: TimeInterval) {
        self.totalCountedValue = value
    }
    
    func setEffectiveValue(_ value: TimeInterval) {
        self.effectiveValue = value
    }
    
    func setDefaultValue(_ value: TimeInterval) {
        self.defultValue = value
    }
    
    func resetToDefaultValue() {
        totalCountedValue = defultValue
    }
}

