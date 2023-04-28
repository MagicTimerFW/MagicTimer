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
    
    // MARK: - Get only properties
        
    public private(set) var lastState: MagicTimerState = .none {
        didSet {
            lastStateDidChangeHandler?(lastState)
        }
    }
        
    public private(set) var elapsedTime: TimeInterval = 0 {
        didSet {
            elapsedTimeDidChangeHandler?(elapsedTime)
        }
    }
    
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
            self.lastState = .fired
            self.observeScheduleTimer()
        }    
    }
    
    /// Stop the timer.
    public func stop() {
        executive.suspand()
        lastState = .stopped
    }
    
    /// Reset the timer. It will set the elapsed time to zero.
    public func reset() {
        executive.suspand()
        counter.resetTotalCounted()
        lastState = .restarted
    }
    
    /// Reset the timer to the default value.
    public func resetToDefault() {
        executive.suspand()
        counter.resetToDefaultValue()
        lastState = .restarted
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
        
    private func observeScheduleTimer() {
        executive.scheduleTimerHandler = { [weak self] in
            guard let self else { return }
            
            switch self.countMode {
            case .stopWatch:
                self.counter.add()
                self.elapsedTime = self.counter.totalCountedValue
            case .countDown(let fromSeconds):
                // Checking if defaultValue plus fromSeconds not going to invalid format(negative seconds).
                guard (self.defultValue + fromSeconds).truncatingRemainder(dividingBy: self.effectiveValue).isEqual(to: .zero) else {
                    fatalError("The time does not leading to valid format. Use valid effetiveValue")
                }
                
                self.counter.setTotalCountedValue(fromSeconds)
                
                // Every timeInterval observe value is called.
                self.executive.scheduleTimerHandler = { [weak self] in
                    // Check if totalCountedValue is valid or not.
                    guard let self else { return }
                    guard self.counter.totalCountedValue.isBiggerThan(.zero) else {
                        self.executive.suspand()
                        self.lastState = .stopped
                        return
                    }
                    // Subtract effectiveValue from totalCountedValue.
                    self.counter.subtract()
                    // Tell the delegate totalCountedValue(elapsed time).
                    self.elapsedTime = self.counter.totalCountedValue
                }
            }
        }
    }
}

