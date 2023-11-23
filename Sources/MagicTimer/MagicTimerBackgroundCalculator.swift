import UIKit
import MathOperators

public protocol MagicTimerBackgroundCalculatorInterface {
    /// The timer fired date.
    var timerFiredDate: Date? { get set }
    /// By changing this type timer decides to whether calcualte the time in background.
    var isActiveBackgroundMode: Bool { get set }
    
    var backgroundTimeCalculateHandler: ((TimeInterval) -> Void)? { get set }
}

public final class MagicTimerBackgroundCalculator: MagicTimerBackgroundCalculatorInterface {
    
    public var timerFiredDate: Date?
    public var isActiveBackgroundMode: Bool = true
    public var backgroundTimeCalculateHandler: ((TimeInterval) -> Void)?
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  
    private func invalidateFiredDate() {
        timerFiredDate = nil
    }
    
    private func calculateDateDiffrence() -> TimeInterval? {
        guard let timerFiredDate else { return nil }
        let validTimeSubtraction = abs(timerFiredDate - Date())
        return validTimeSubtraction.convertToTimeInterval()
    }
    
    @objc
    private func willEnterForegroundNotification() {
        guard isActiveBackgroundMode else { return }
        
        if let timeInterval = calculateDateDiffrence() {
            backgroundTimeCalculateHandler?(timeInterval)
        }
    }
}

