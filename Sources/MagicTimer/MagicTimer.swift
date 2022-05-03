import Foundation
import MagicTimerCore

@available(*, unavailable, renamed: "MGTimerMode")
/// The timer counting mode.
public enum MGCountMode {
    case stopWatch
    case countDown(fromSeconds: TimeInterval)
}


public enum MGTimerMode {
    case stopWatch
    case countDown(fromSeconds: TimeInterval)
}


/**
 A broker between contianer and view.
 
 Every time calculation or any commands are managing in MagicTimer that contains counter, executive and background time calculator.
 */

public class MagicTimer {
    
    public typealias StateHandler = ((MagicTimerState) -> Void)
    public typealias ElapsedTimeHandler = ((TimeInterval) -> Void)
    
    private var counter: MGCounterBehavior
    private var executive: MGExecutiveBehavior
    private var backgroundCalculator: MGBackgroundCalculableBehavior

    open private(set) var lastState: MagicTimerState = .none
    
    @available(*, unavailable, renamed: "lastStateDidChangeHandler")
    /// Timer state callback
    public var didStateChange: ((MagicTimerState) -> Void)?
    
    /// Timer state callback
    public var lastStateDidChangeHandler: StateHandler?
    
    @available(*, unavailable, renamed: "elapsedTimeDidChangeHandler")
    /// A elpsed time that can observe
    public var observeElapsedTime: ((TimeInterval) -> Void)?
    
    /// A elpsed time that can observe
    public var elapsedTimeDidChangeHandler: ElapsedTimeHandler?
    
    private(set) var elapsedTime: TimeInterval = 0
    
    /// Set value to counter defultValue.
    public var defultValue: TimeInterval = 0 {
        willSet {
            guard newValue >= 0 else {
                fatalError("The defultValue should be greater or equal to zero.")
            }
            counter.setDefaultValue(newValue)
        }
    }
    /// Set value to counter effectiveValue.
    public var effectiveValue: TimeInterval = 1 {
        willSet {
            guard newValue >= 0 else {
                fatalError("The effectiveValue should be greater or equal to zero.")
            }
            counter.setEffectiveValue(newValue)
        }
    }
    /// Set time interval to executive timeInerval.
    public var timeInterval: TimeInterval = 1  {
        willSet {
            // TODO: make extension for math operators.
            guard newValue >= 0 else {
                fatalError("The timeInterval should be greater or equal to zero.")
            }
            executive.timeInerval = newValue
        }
    }
    /// Set value to  backgroundCalculator isActiveBackgroundMode property.
    public var isActiveInBackground: Bool = false {
        willSet {
            backgroundCalculator.isActiveBackgroundMode = newValue
        }
    }
    /// Timer count mode.
    public var countMode: MGTimerMode = .stopWatch
    
    @available(*, unavailable, renamed: "lastState")
    /// The current state of the timer.
    public var currentState: MagicTimerState {
        return lastState
    }
    
    public init() {
        counter = MGCounter()
        executive = MGTimerExecutive()
        backgroundCalculator = MGBackgroundCalculator()
        
        backgroundCalculator.backgroundTimeCalculateHandler = { elapsedTime in
            self.calclulateBackgroundTime(elapsedTime: elapsedTime)
        }
        
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

        executive.scheduleTimerHandler = {
            self.counter.add()
            self.elapsedTimeDidChangeHandler?(self.counter.totalCountedValue)
        }
    }
  
    private func countDown(fromSeconds: TimeInterval) {
        // Checking if defaultValue plus fromSeconds not going to invalid format(negative seconds).
        guard (defultValue + fromSeconds).truncatingRemainder(dividingBy: effectiveValue ) == 0 else {
            fatalError("The time does not leading to valid format. Use valid effetiveValue")
        }
        
        counter.setTotalCountedValue(fromSeconds)
        
        // Every timeInterval observe value is called.
        executive.scheduleTimerHandler = {
            // Check if totalCountedValue is valid or not.
            guard self.counter.totalCountedValue > 0 else {
                self.executive.suspand()
                self.lastStateDidChangeHandler?(.stopped)

                return
            }
            // Subtract effectiveValue from totalCountedValue.
            self.counter.subtract()
            // Tell the delegate totalCountedValue(elapsed time).
            self.elapsedTimeDidChangeHandler?(self.counter.totalCountedValue)
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
        lastState = .fired
        lastStateDidChangeHandler?(.fired)

    }
    /// Stop timer counting.
    public func stop() {
        executive.suspand()
        lastState = .stopped
        lastStateDidChangeHandler?(.stopped)
    }
    /// Reset timer to zero
    public func reset() {
        executive.suspand()
        counter.resetTotalCounted()
        lastState = .restarted
        lastStateDidChangeHandler?(.restarted)
        
    }
    /// Reset timer to default value
    public func resetToDefault() {
        executive.suspand()
        counter.resetToDefaultValue()
        lastState = .restarted
        lastStateDidChangeHandler?(.restarted)
    }
}

