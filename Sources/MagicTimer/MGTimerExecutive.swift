

import Foundation

protocol MGExecutiveTimerBehavior {
    /// A core timer of module.
    var scheduleTimer: Timer? { get }
    /// The timer time interval.
    var timeInerval: TimeInterval { get }
    /// Create sheduleTImer and observe element in each timeInerval.
    func start(compeltion: (() -> Void)?)
    /// Invalidate the core timer.
    func suspand()
    /// Set value to timeInerval.
    /// - Parameter value: time
    func setTimeInterval(_ value: TimeInterval)
    /// Current state of timer
    var state: MagicTimerState { get set }
}
/// A Observebale type that have timer managing behavior
protocol MGObservableTimerBehavior: MGExecutiveTimerBehavior, MGObservableBehavior {
    
}
/**
 A type that manage core timer. For example starting or suspanding.
 */
class MGTimerExecutive: MGObservableTimerBehavior, MGLogable {
    
    
    var observeValue: (() -> Void)?
    var scheduleTimer: Timer?
    var timeInerval: TimeInterval = 1.0
    var state: MagicTimerState = .none

    func start(compeltion: (() -> Void)?) {
        // Check if timer is not fired
        guard state != .fired else { return }
        // Create instane of timer and assign to scheduleTimer
        scheduleTimer = Timer.scheduledTimer(withTimeInterval: timeInerval, repeats: true, block: { [weak self] _ in
            // Observe value every defined time interval
            self?.observeValue!()
            
        })
        state = .fired
        // Add timer to custom Runloop
        RunLoop.main.add(scheduleTimer!, forMode: .common)
        
        guard compeltion != nil else { return }
        compeltion!()
    }
    
    func suspand() {
        // Invalidate core timer
        scheduleTimer?.invalidate()
        state = .stopped
    }
    
    func setTimeInterval(_ value: TimeInterval) {
        self.timeInerval = value
    }
    
}
