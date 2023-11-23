import Foundation

public protocol MagicTimerExecutiveInterface {
    /// Timer time interval.
    var timeInterval: TimeInterval { get set }
    /// Fire the timer.
    func fire(compeltionHandler: (() -> Void)?)
    /// Suspand the timer.
    func suspand(completionHandler: (() -> Void)?)
    /// A call back which is called on every time interval.
    var scheduleTimerHandler: (() -> Void)? { get set }
}

public final class MagicTimerExecutive: MagicTimerExecutiveInterface {
    
    // MARK: - Public properties
    public var scheduleTimerHandler: (() -> Void)?
    public var timeInterval: TimeInterval = 1.0
    
    // MARK: - Private
    private var scheduleTimer: Timer?
    private var isTimerAlreadyStarted: Bool = false

    // MARK: - Constructors
    public init() {
        scheduleTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            self?.scheduleTimerHandler?()
        })
    }
    
    // MARK: - Public methods
    public func fire(compeltionHandler: (() -> Void)?) {
        isTimerAlreadyStarted = true
        scheduleTimer?.fire()
        RunLoop.main.add(scheduleTimer!, forMode: .common)
        compeltionHandler?()
    }
    
    public func suspand(completionHandler: (() -> Void)?) {
        scheduleTimer?.invalidate()
        isTimerAlreadyStarted = false
        completionHandler?()
    }
}
