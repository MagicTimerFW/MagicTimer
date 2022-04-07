
import Foundation
import UIKit

/// A type that every calculable object must conform
protocol MGBackgroundCalculableBehavior: MGObservebaleTimeInterval {
    /// The timer firing date
    var timerFiredDate: Date? { get }
    /// A Boolean value that determines whether the  is background mode active
    var isActiveBackgroundMode: Bool { get set }
    /// Calculate time diffrence between two date
    func calculateDateDiffrence() -> TimeInterval?
    /// Set timer firing date
    func setTimeFiredDate(_ value: Date)
    /// Current state of timer
    var state: MagicTimerState { get set }
}

class MGBackgroundCalculator: MGBackgroundCalculableBehavior, MGLogable {
    
    public var timerFiredDate: Date?
    public var isActiveBackgroundMode: Bool = false
    public var observe: ((TimeInterval) -> Void)?
    var isFirstForegroundNotification: Bool = true
    public var state: MagicTimerState = .none
    
    init() {

     NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
      
        log(message: "initialized")
    }
    
    @objc private func willEnterForegroundNotification() {
        /// Check if background mode is activated
        guard isActiveBackgroundMode else { return }
        
        if  state == .fired {
            /// Calculate time diffrence between two date
            if let timeInterval = calculateDateDiffrence() {
                observe!(timeInterval)
                
            }
            log(message: "background time calculation completed")
        }
        
        

    
    }
  
    /// Set nil value to timerFiredDate
    func invalidateFiredDate() {
        timerFiredDate = nil
    }
    /// Calculate time diffrence between two date
    public func calculateDateDiffrence() -> TimeInterval? {
        guard timerFiredDate != nil else { return nil }
        let validTimeSubtraction = abs(timerFiredDate! - Date())
        return validTimeSubtraction.convertToTimeInterval()
        
    }
    /// Set timer firing date
    public func setTimeFiredDate(_ value: Date) {
        self.timerFiredDate = value
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
