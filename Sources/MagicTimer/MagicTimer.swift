

import Foundation
import UIKit

/// A type that make standard behavior to constraintable view.
protocol StandardConstraintableView {
    /// Set constraint of the elements
    func setConstraint()
    /// Add subview or any installation
    func initialSubView()
}

/// The timer counting mode.
public enum MGCountMode {
    case stopWatch
    case countDown(fromSeconds: TimeInterval)
}
/**
 A broker between contianer and view.
 
 Every time calculation or any commands are managing in MagicTimer that contains counter, executive and background time calculator.
 */

public class MagicTimer: MGLogable {
        
    private var counter: MGCounterBehavior
    private var executive: MGObservableTimerBehavior
    private var backgroundCalculator: MGBackgroundCalculableBehavior
    
    private var state: MagicTimerState = .none {
        willSet {
            executive.state = newValue
            backgroundCalculator.state = newValue
            
        }
    }
    
    /// Timer state callback
    public var didStateChange: ((MagicTimerState) -> Void)?
    
    /// A elpsed time that can observe
    public var observeElapsedTime: ((TimeInterval) -> Void)?
    
    /// Set value to counter defultValue.
    public var defultValue: TimeInterval = 0 {
        willSet {
            let positiveValue = max(0, newValue)
            counter.setDefaultValue(positiveValue)
        }
    }
    /// Set value to counter effectiveValue.
    public var effectiveValue: TimeInterval = 1 {
        willSet {
            let positiveValue = max(0, newValue)
            counter.setEffectiveValue(positiveValue)
        }
    }
    /// Set time interval to executive timeInerval.
    public var timeInterval: TimeInterval = 1  {
        willSet {
            let positiveValue = max(0, newValue)
            executive.setTimeInterval(positiveValue)
        }
    }
    /// Set value to  backgroundCalculator isActiveBackgroundMode property.
    public var isActiveInBackground: Bool = false {
        willSet {
            backgroundCalculator.isActiveBackgroundMode = newValue
        }
    }
    /// State of time counting.
    public var countMode: MGCountMode = .stopWatch
    
    /// The current state of the timer.
    public var currentState: MagicTimerState {
        return state
    }
    
    public init() {
        counter = MGCounter()
        executive = MGTimerExecutive()
        backgroundCalculator = MGBackgroundCalculator()
        
        backgroundCalculator.observe = { elapsedTime in
            
            self.calclulateBackgroundTime(elapsedTime: elapsedTime)
        }
        log(message: "initialized")
    }
    // Calculate time in background
    private func calclulateBackgroundTime(elapsedTime: TimeInterval) {
        switch countMode {
        case .stopWatch:
            // Set totalCountedValue to all elpased time plus time in background.
             counter.setTotalCountedValue(elapsedTime)
        case let .countDown(fromSeconds: countDownSeconds):
            
            let subtraction = countDownSeconds - elapsedTime
            // Checking elapsed time in background wasn't negeative.
            if subtraction.isPositive {
                // Set totalCountedValue to total time minus elapsed time in background.
                counter.setTotalCountedValue(subtraction)
            } else {
                counter.setTotalCountedValue(1)
            }
        }
    }
    
    private func countUp() {

        executive.observeValue = {
            self.counter.add()
            self.observeElapsedTime?(self.counter.totalCountedValue)
        }
    }
  
    private func countDown(fromSeconds: TimeInterval) {
        // Checking if defaultValue plus fromSeconds not going to invalid format(negative seconds).
        guard (defultValue + fromSeconds).truncatingRemainder(dividingBy: effectiveValue ) == 0 else {
            fatalError("The time does not leading to valid format. Use valid effetiveValue")
        }
        
        counter.setTotalCountedValue(fromSeconds)
        
        // Every timeInterval observe value is called.
        executive.observeValue = {
            // Check if totalCountedValue is valid or not.
            guard self.counter.totalCountedValue > 0 else {
                self.executive.suspand()
                self.didStateChange?(.stopped)

                return
            }
            // Subtract effectiveValue from totalCountedValue.
            self.counter.subtract()
            // Tell the delegate totalCountedValue(elapsed time).
            self.observeElapsedTime?(self.counter.totalCountedValue)
        }
    }
    
    /// Observe counting mode and start counting.
    public func start() {
        
        executive.start {
            // Set current date to timer firing date(for calculate background elapsed time). When set the time is not fired.
            self.backgroundCalculator.setTimeFiredDate(Date())
        }
        
        switch countMode {
        case let .countDown(fromSeconds: seconds):
            countDown(fromSeconds: seconds)
        case .stopWatch:
            countUp()
        }
        state = .fired
        didStateChange?(.fired)

        log(message: "timer started")
    }
    /// Stop timer counting.
    public func stop() {
        executive.suspand()
        state = .stopped
        didStateChange?(.stopped)

        log(message: "timer stopped")
    }
    /// Reset timer to zero
    public func reset() {
        executive.suspand()
        counter.resetTotalCounted()
        state = .restarted
        didStateChange?(.restarted)

        log(message: "timer restarted")
        
    }
    /// Reset timer to default value 
    public func resetToDefault() {
        executive.suspand()
        counter.resetToDefaultValue()
        state = .restarted
        didStateChange?(.restarted)
        log(message: "timer restarted to default")

    }
}

