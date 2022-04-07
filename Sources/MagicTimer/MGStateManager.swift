
import Foundation

///// A type that save state.
@available(*, deprecated, message: "MGStateManager is no longer available. Use MagicTimerState insted ")
public class MGStateManager {
    /// Shared instance for managing state.
    static let shared: MGStateManager = .init()
    /// Kind of possible timer state 
    public enum TimerState {
        case fired
        case stopped
        case restarted
        case none
    }
    /// The current state of timer. Default is none
    public var currentTimerState: TimerState = .none
    
}
