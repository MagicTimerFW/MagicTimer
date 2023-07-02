@available(*, deprecated, message: "MGStateManager is no longer available. Use MagicTimerState insted ")
public class MGStateManager {
    static let shared: MGStateManager = .init()
    public enum TimerState {
        case fired
        case stopped
        case restarted
        case none
    }
    public var currentTimerState: TimerState = .none    
}

public enum MagicTimerState {
    case fired
    case stopped
    case restarted
    case none
}
