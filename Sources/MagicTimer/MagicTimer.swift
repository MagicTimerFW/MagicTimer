import Foundation
import MagicTimerCore
import MathOperators

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

/// The MagicTimer implements a timer with different modes (stop watch, and count down) that supports background mode calculations.
public class MagicTimer {
    
    // MARK: - Typealias
    public typealias StateHandler = ((MagicTimerState) -> Void)
    public typealias ElapsedTimeHandler = ((TimeInterval) -> Void)
    
    // MARK: - Public properties
    
    // MARK: - Handlers
    
    /// Last state of the timer handler. It calls when state of timer changes.
    public var lastStateDidChangeHandler: StateHandler?
    
    /// Elapsed time handler. It calls on each timeInterval.
    public var elapsedTimeDidChangeHandler: ElapsedTimeHandler?
    
    // MARK: - Get only
        
    public private(set) var lastState: MagicTimerState = .none
        
    public private(set) var elapsedTime: TimeInterval = 0
    
    /// Timer count mode.
    public var countMode: MGTimerMode = .stopWatch
    
    /// Set value to counter defultValue.
    public var defultValue: TimeInterval = 0 {
        willSet {
            guard newValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The defultValue should be greater or equal to zero.")
            }
            counter.setDefaultValue(newValue)
        }
    }
    
    /// Set value to counter effectiveValue.
    public var effectiveValue: TimeInterval = 1 {
        willSet {
            guard newValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The effectiveValue should be greater or equal to zero.")
            }
            counter.setEffectiveValue(newValue)
        }
    }
    
    /// Set time interval to executive timeInerval.
    public var timeInterval: TimeInterval = 1  {
        willSet {
            guard newValue.isBiggerThanOrEqual(.zero) else {
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
    
    // MARK: - Private
        
    private var counter: MGCounterBehavior
    private var executive: MGExecutiveBehavior
    private var backgroundCalculator: MGBackgroundCalculableBehavior

    // MARK: - Unavailable
    
    @available(*, unavailable, renamed: "elapsedTimeDidChangeHandler")
    /// A elpsed time that can observe
    public var observeElapsedTime: ((TimeInterval) -> Void)?
    
    @available(*, unavailable, renamed: "lastState")
    /// The current state of the timer.
    public var currentState: MagicTimerState {
        return lastState
    }
    
    @available(*, unavailable, renamed: "lastStateDidChangeHandler")
    /// Timer state callback
    public var didStateChange: ((MagicTimerState) -> Void)?
    
    // MARK: - Constructor
    
    public init(counter: MGCounterBehavior = MGCounter(),
                executive: MGExecutiveBehavior = MGTimerExecutive(),
                backgroundCalculator: MGBackgroundCalculableBehavior = MGBackgroundCalculator()) {
        self.counter = counter
        self.executive = executive
        self.backgroundCalculator = backgroundCalculator
        self.backgroundCalculator.backgroundTimeCalculateHandler = { elapsedTime in
            self.calclulateBackgroundTime(elapsedTime: elapsedTime)
        }
    }
    
    // MARK: - Public methods
    
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
    
    /// Reset timer to zero.
    public func reset() {
        executive.suspand()
        counter.resetTotalCounted()
        lastState = .restarted
        lastStateDidChangeHandler?(.restarted)
        
    }
    
    /// Reset timer to default value.
    public func resetToDefault() {
        executive.suspand()
        counter.resetToDefaultValue()
        lastState = .restarted
        lastStateDidChangeHandler?(.restarted)
    }
    
    // MARK: - Private methods
    
    // Calculate time in background.
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
        guard (defultValue + fromSeconds).truncatingRemainder(dividingBy: effectiveValue ).isEqual(to: .zero) else {
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
}

