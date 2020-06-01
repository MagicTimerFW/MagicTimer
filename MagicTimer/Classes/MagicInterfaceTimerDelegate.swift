

import Foundation

/// Methods for get information from MagicInterfaceTimer.
public protocol MagicInterfaceTimerDelegate: AnyObject {
    func timerElapsedTimeDidChange(timer: MagicInterfaceTimer, elapsedTime: TimeInterval)
}

public extension MagicInterfaceTimerDelegate {
    
    func timerElapsedTimeDidChange(timer: MagicInterfaceTimer, elapsedTime: TimeInterval) {
        
    }
}
