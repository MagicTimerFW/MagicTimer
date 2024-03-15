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
    
    private var shouldCalculate: Bool = false
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  
    private func invalidateFiredDate() {
        timerFiredDate = nil
    }
    
    private func calculateDateDiffrence() -> TimeInterval? {
        guard let timerFiredDate else { return nil }
        let validTimeSubtraction = floor(abs(timerFiredDate - Date()))
        return validTimeSubtraction.convertToTimeInterval()
    }
    
    @objc
    private func willEnterForegroundNotification() {
        guard isActiveBackgroundMode, shouldCalculate else { return }
        
        if let timeInterval = calculateDateDiffrence() {
            backgroundTimeCalculateHandler?(timeInterval)
        }
    }
    
    @objc
    private func willEnterBackgroundNotification() {
        shouldCalculate = true
    }
}

