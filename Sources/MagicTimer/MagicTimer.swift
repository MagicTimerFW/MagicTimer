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
    
    /// Last state of the timer. Checkout ```MagicTimerState```.
    public private(set) var lastState: MagicTimerState = .none {
        didSet {
            lastStateDidChangeHandler?(lastState)
        }
    }
    
    /// Elapsed time from where the timer started. Default is 0.
    public private(set) var elapsedTime: TimeInterval = 0 {
        didSet {
            elapsedTimeDidChangeHandler?(elapsedTime)
        }
    }
    
    /// Timer count mode. Default is `.stopWatch`. Checkout ```MGTimerMode```
    public var countMode: MGTimerMode = .stopWatch
    
    /// Timer default value. Default is 0.
    public var defultValue: TimeInterval = 0 {
        willSet {
            guard newValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The defultValue should be greater or equal to zero.")
            }
            counter.defultValue = newValue
        }
    }
    
    /// Timer effective value. Default is 1.
    public var effectiveValue: TimeInterval = 1 {
        willSet {
            guard newValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The effectiveValue should be greater or equal to zero.")
            }
            counter.effectiveValue = newValue
        }
    }
    
    /// Timer time interval, Default is 1.
    public var timeInterval: TimeInterval = 1  {
        willSet {
            guard newValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The timeInterval should be greater or equal to zero.")
            }
            executive.timeInterval = newValue
        }
    }
    
    /// Set value to backgroundCalculator isActiveBackgroundMode property.
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
    
    // MARK: - Constructors
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
    /// Start counting the timer.
    public func start() {
        executive.start {
            self.backgroundCalculator.timerFiredDate = Date()
            self.lastState = .fired
            self.observeScheduleTimer()
        }    
    }
    
    /// Stop counting the timer.
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
    // It calculates the elapsed time user was in background.
    private func calclulateBackgroundTime(elapsedTime: TimeInterval) {
        switch countMode {
        case .stopWatch:
             counter.totalCountedValue = elapsedTime
        case let .countDown(fromSeconds: countDownSeconds):
            
            let subtraction = countDownSeconds - elapsedTime
            if subtraction.isPositive {
                counter.totalCountedValue = subtraction
            } else {
                counter.totalCountedValue = 1
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
                    fatalError("The time does not lead to a valid format. Use valid effetiveValue")
                }
                
                self.counter.totalCountedValue = fromSeconds
                
                self.executive.scheduleTimerHandler = { [weak self] in
                    guard let self else { return }
                    guard self.counter.totalCountedValue.isBiggerThan(.zero) else {
                        self.executive.suspand()
                        self.lastState = .stopped
                        return
                    }
                    self.counter.subtract()
                    self.elapsedTime = self.counter.totalCountedValue
                }
            }
        }
    }
}

