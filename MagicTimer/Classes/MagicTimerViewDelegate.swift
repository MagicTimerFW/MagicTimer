

import Foundation

/// Methods for get information from MagicInterfaceTimer.
public protocol MagicTimerViewDelegate: AnyObject {
    func timerElapsedTimeDidChange(timer: MagicTimerView, elapsedTime: TimeInterval)
}

public extension MagicTimerViewDelegate {
    
    func timerElapsedTimeDidChange(timer: MagicTimerView, elapsedTime: TimeInterval) {
        
    }
}
