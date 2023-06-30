# MagicTimer 

The `MagicTimer` class is a timer implementation written in Swift. It provides various functionalities to start, stop, reset, background time calculation and observe the elapsed time. The class uses a set of handler closures to notify the changes in the timer's state and elapsed time.

## Typealiases

```swift
public typealias StateHandler = ((MagicTimerState) -> Void)
public typealias ElapsedTimeHandler = ((TimeInterval) -> Void)
```

- `StateHandler`: A closure type that takes a `MagicTimerState` parameter, representing the timer's state, and returns `Void`. This closure is called when the state of the timer changes.
- `ElapsedTimeHandler`: A closure type that takes a `TimeInterval` parameter, representing the elapsed time, and returns `Void`. This closure is called on each time interval to update the elapsed time.

## Public Properties

- `lastStateDidChangeHandler`: A closure that is called when the state of the timer changes.
- `elapsedTimeDidChangeHandler`: A closure that is called on each time interval to update the elapsed time.

```swift
public var lastStateDidChangeHandler: StateHandler?
public var elapsedTimeDidChangeHandler: ElapsedTimeHandler?
```

- `lastState`: A read-only property representing the last state of the timer. Checkout `MagicTimerState`.

```swift
public private(set) var lastState: MagicTimerState = .none {
    didSet {
        lastStateDidChangeHandler?(lastState)
    }
}
```

- `elapsedTime`: A read-only property representing the elapsed time from when the timer started. Default is 0.

```swift
public private(set) var elapsedTime: TimeInterval = 0 {
    didSet {
        elapsedTimeDidChangeHandler?(elapsedTime)
    }
}
```

- `countMode`: Timer count mode. Default is `.stopWatch`. Checkout `MGTimerMode`.

```swift
public var countMode: MGTimerMode = .stopWatch
```

- `defultValue`: Timer default value. Default is 0.

```swift
public var defultValue: TimeInterval = 0 {
    willSet {
        guard newValue.isBiggerThanOrEqual(.zero) else {
            fatalError("The defultValue should be greater or equal to zero.")
        }
        counter.defultValue = newValue
    }
}
```

- `effectiveValue`: A number which is added or minused on each `timeInterval`. Default is 1.

```swift
public var effectiveValue: TimeInterval = 1 {
    willSet {
        guard newValue.isBiggerThanOrEqual(.zero) else {
            fatalError("The effectiveValue should be greater or equal to zero.")
        }
        counter.effectiveValue = newValue
    }
}
```

- `timeInterval`: Timer time interval, Default is 1.

```swift
public var timeInterval: TimeInterval = 1  {
    willSet {
        guard newValue.isBiggerThanOrEqual(.zero) else {
            fatalError("The timeInterval should be greater or equal to zero.")
        }
        executive.timeInterval = newValue
    }
}
```

- `isActiveInBackground`: By changing this type, the timer decides whether to calculate the time in the background. Default is true.

```swift
public var isActiveInBackground: Bool = true {
    willSet {
        backgroundCalculator.isActiveBackgroundMode = newValue
    }
}
```
