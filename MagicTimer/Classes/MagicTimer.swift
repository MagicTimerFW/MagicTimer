

import Foundation
import UIKit

/// A type that make standard behavior to constraintable view.
protocol StandardConstraintableView {
    /// Set constraint of the elements
    func setConstraint()
    /// Add subview or any installation
    func initialSubView()
}

/// The container that contains counter and executive.
class MGTimerContainer: MGLogable {
    
    var counter: MGCounterBehavior
    var executive: MGObservableTimerBehavior
    
    init(counter: MGCounterBehavior, executive: MGObservableTimerBehavior) {
        self.counter = counter
        self.executive = executive
        log(message: "initialized")
    }
}

/// Methods for observe time interval from timer broker.
public protocol MagicTimerDelegate: AnyObject {
    func observeTimeInterval(_ ti: TimeInterval)
}
/// The timer counting mode.
public enum MGCountMode {
    case stopWatch
    case countDown(fromSeconds: TimeInterval)
}
/**
 A broker between contianer and view.
 
 Every time calculation or any commands are managing in MGTimerBroker that contains counter, executive and background time calculator.
 */

public class MagicTimer: MGLogable {
        
    private var container: MGTimerContainer
    private var backgroundCalculator: MGBackgroundCalculableBehavior
    private var state: MGStateManager = .shared
    
    /// The object that acts as the delegate of the MagicTimer..
    public weak var delegate: MagicTimerDelegate?
    
    /// Set value to counter defultValue.
    public var defultValue: TimeInterval = 0 {
        willSet {
            let positiveValue = max(0, newValue)
            container.counter.setDefaultValue(positiveValue)
        }
    }
    /// Set value to counter effectiveValue.
    public var effectiveValue: TimeInterval = 1 {
        willSet {
            let positiveValue = max(0, newValue)
            container.counter.setEffectiveValue(positiveValue)
        }
    }
    /// Set time interval to executive timeInerval.
    public var timeInterval: TimeInterval = 1  {
        willSet {
            let positiveValue = max(0, newValue)
            container.executive.setTimeInterval(positiveValue)
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
    public var currentState: MGStateManager.TimerState {
        return state.currentTimerState
    }
    
    public init() {
        self.container = MGTimerContainer(counter: MGCounter(), executive: MGTimerExecutive())
        self.backgroundCalculator = MGBackgroundCalculator()
        
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
             container.counter.setTotalCountedValue(elapsedTime)
        case let .countDown(fromSeconds: countDownSeconds):
            
            let subtraction = countDownSeconds - elapsedTime
            // Checking elapsed time in background wasn't negeative.
            if subtraction.isPositive {
                // Set totalCountedValue to total time minus elapsed time in background.
                container.counter.setTotalCountedValue(subtraction)
            } else {
                container.counter.setTotalCountedValue(1)
            }
        }
    }
    
    private func countUp() {
        log(message: "Count mode is \(countMode)")

        container.executive.observeValue = {
            self.container.counter.add()
            self.delegate?.observeTimeInterval(self.container.counter.totalCountedValue)
        }
    }
  
    private func countDown(fromSeconds: TimeInterval) {
        log(message: "Count mode is \(countMode)")
        // Checking if defaultValue plus fromSeconds not going to invalid format(negative seconds).
        guard (defultValue + fromSeconds).truncatingRemainder(dividingBy: effectiveValue ) == 0 else {
            fatalError("The time does not leading to valid format. Use valid effetiveValue")
        }
        
        container.counter.setTotalCountedValue(fromSeconds)
        
        // Every timeInterval observe value is called.
        container.executive.observeValue = {
            // Check if totalCountedValue is valid or not.
            guard self.container.counter.totalCountedValue > 0 else {
                self.container.executive.suspand()
                return
            }
            // Subtract effectiveValue from totalCountedValue.
            self.container.counter.subtract()
            // Tell the delegate totalCountedValue(elapsed time).
            self.delegate?.observeTimeInterval(self.container.counter.totalCountedValue)
        }
    }
    
    /// Observe counting mode and start counting.
    public func start() {
        
        container.executive.start {
            // Set current date to timer firing date(for calculate background elapsed time). When set the time is not fired.
            self.backgroundCalculator.setTimeFiredDate(Date())
        }
        
        switch countMode {
        case let .countDown(fromSeconds: seconds):
            countDown(fromSeconds: seconds)
        case .stopWatch:
            countUp()
        }
        state.currentTimerState = .fired
        log(message: "timer started")
    }
    /// Stop timer counting.
    public func stop() {
        container.executive.suspand()
        state.currentTimerState = .stopped
        log(message: "timer stopped")
    }
    /// Reset timer to zero
    public func reset() {
        container.executive.suspand()
        container.counter.resetTotalCounted()
        state.currentTimerState = .restarted
        log(message: "timer restarted")
        
    }
    /// Reset timer to default value 
    public func resetToDefault() {
        container.executive.suspand()
        container.counter.resetToDefaultValue()
        state.currentTimerState = .restarted
        log(message: "timer restarted to default")

    }
}

