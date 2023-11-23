import Foundation
import MathOperators

@available(*, unavailable, renamed: "MagicTimerMode")
/// The timer counting mode.
public enum MGCountMode {
    case stopWatch
    case countDown(fromSeconds: TimeInterval)
}

public enum MagicTimerMode {
    case stopWatch
    case countDown(fromSeconds: TimeInterval)
}

/// The MagicTimer class is a timer implementation. It provides various functionalities to start, stop, reset, background time calculation and more.
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
    
    /// Timer count mode. Default is `.stopWatch`. Checkout ```MagicTimerMode```.
    public var countMode: MagicTimerMode = .stopWatch
    
    /// Timer default value. Default is 0.
    public var defultValue: TimeInterval = 0 {
        didSet {
            guard defultValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The defultValue should be greater or equal to zero.")
            }
            counter.defultValue = defultValue
        }
    }
    
    /// A number which is added or minused on each ``timeInterval``. Default is 1.
    public var effectiveValue: TimeInterval = 1 {
        didSet {
            guard effectiveValue.isBiggerThanOrEqual(.zero) else {
                fatalError("The effectiveValue should be greater or equal to zero.")
            }
            counter.effectiveValue = effectiveValue
        }
    }
    
    /// Timer time interval. Default is 1.
    public var timeInterval: TimeInterval = 1  {
        didSet {
            guard timeInterval.isBiggerThanOrEqual(.zero) else {
                fatalError("The timeInterval should be greater or equal to zero.")
            }
            executive.timeInterval = timeInterval
        }
    }
    
    /// By changing this type timer decides to whether calcualte the time in background. Default is true.
    public var isActiveInBackground: Bool = true {
        didSet {
            backgroundCalculator.isActiveBackgroundMode = isActiveInBackground
        }
    }
    
    // MARK: - Private properties
    private var counter: MagicTimerCounterInterface
    private var executive: MagicTimerExecutiveInterface
    private var backgroundCalculator: MagicTimerBackgroundCalculatorInterface

    // MARK: - Unavailable
    /// A elapsed time that can observe
    /// - Warning: renamed: "elapsedTimeDidChangeHandler"
    public var observeElapsedTime: ((TimeInterval) -> Void)?
    
    /// The current state of the timer.
    /// - Warning: renamed: "lastState"
    public var currentState: MagicTimerState {
        return lastState
    }
    
    /// Timer state callback
    /// - Warning: renamed: "lastStateDidChangeHandler"
    public var didStateChange: ((MagicTimerState) -> Void)?
    
    // MARK: - Constructors
    public init(counter: MagicTimerCounterInterface = MagicTimerCounter(),
                executive: MagicTimerExecutiveInterface = MagicTimerExecutive(),
                backgroundCalculator: MagicTimerBackgroundCalculatorInterface = MagicTimerBackgroundCalculator()) {
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
        executive.fire {
            self.backgroundCalculator.timerFiredDate = Date()
            self.lastState = .fired
            self.observeScheduleTimer()
        }    
    }
    
    /// Stop counting the timer.
    public func stop() {
        executive.suspand {
            self.lastState = .stopped
        }
    }
    
    /// Reset the timer. It will set the elapsed time to zero.
    public func reset() {
        executive.suspand {
            self.counter.resetTotalCounted()
            self.lastState = .restarted
        }
    }
    
    /// Reset the timer to the ``defaultvalue``.
    public func resetToDefault() {
        executive.suspand {
            self.counter.resetToDefaultValue()
            self.lastState = .restarted
        }
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
                guard counter.totalCountedValue.isBiggerThan(.zero) else {
                    executive.suspand {
                        self.lastState = .stopped
                    }
                    return
                }
                counter.subtract()
                elapsedTime = self.counter.totalCountedValue
            }
        }
    }
}

