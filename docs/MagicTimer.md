# MagicTimer Class

The `MagicTimer` class is a timer implementation that provides various functionalities to start, stop, reset, and calculate elapsed time. It supports different timer modes, background time calculation, and event handlers.

## Properties

### Handlers

- `lastStateDidChangeHandler`: A handler called when the timer state changes. It provides the last state of the timer.
- `elapsedTimeDidChangeHandler`: A handler called on each time interval. It provides the elapsed time.

### Get-only Properties

- `lastState`: The last state of the timer. It can be one of the following states: `.none`, `.fired`, `.stopped`, or `.restarted`.
- `elapsedTime`: The elapsed time from when the timer started.

### Timer Configuration Properties

- `countMode`: The timer count mode. It can be either `.stopWatch` or `.countDown(fromSeconds: TimeInterval)`.
- `defultValue`: The timer default value. This value is used when resetting the timer.
- `effectiveValue`: The value added or subtracted on each time interval.
- `timeInterval`: The time interval between each timer tick.
- `isActiveInBackground`: Determines whether the timer calculates time in the background.

## Constructors

- `init(counter: MagicTimerCounterInterface = MagicTimerCounter(), executive: MagicTimerExecutiveInterface = MagicTimerExecutive(), backgroundCalculator: MagicTimerBackgroundCalculatorInterface = MagicTimerBackgroundCalculator())`: Initializes a new instance of the `MagicTimer` class with the specified counter, executive, and background calculator.

## Methods

- `start()`: Starts the timer.
- `stop()`: Stops the timer.
- `reset()`: Resets the timer, setting the elapsed time to zero.
- `resetToDefault()`: Resets the timer to the default value.



> Note: The `MagicTimer` class uses the `MagicTimerCounterInterface`, `MagicTimerExecutiveInterface`, and `MagicTimerBackgroundCalculatorInterface` protocols for counter, executive, and background calculator implementations, respectively.

Checkout the documentations:
[MagicTimerCounterInterface](https://github.com/MagicTimerFW/MagicTimerCore/blob/main/docs/MagicTimerCounter.md]MagicTimerCounterInterface), [MagicTimerExecutiveInterface](https://github.com/MagicTimerFW/MagicTimerCore/blob/main/docs/MagicTimerExecutive.md), [MagicTimerBackgroundCalculatorInterface](https://github.com/MagicTimerFW/MagicTimerCore/blob/main/docs/MagicTimerBackgroundCalculator.md
), 

## Usage

```swift
// Create an instance of MagicTimer
let timer = MagicTimer()

// Configure event handlers
timer.lastStateDidChangeHandler = { state in
    // Handle timer state changes
}

timer.elapsedTimeDidChangeHandler = { elapsedTime in
    // Handle elapsed time changes
}

// Start the timer
timer.start()

// ...

// Stop the timer
timer.stop()

// ...

// Reset the timer
timer.reset()

// ...

// Reset the timer to the default value
timer.resetToDefault()
