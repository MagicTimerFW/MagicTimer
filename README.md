# MagicTimer
![MagicTimer logo](https://user-images.githubusercontent.com/43542836/83555945-53b50780-a524-11ea-850e-d10b0839f63b.png)

Welcome to the MagicTimer framework, your ultimate solution for handling timers in your iOS applications. This framework provides a powerful and flexible timer implementation with various features to meet your timer needs.

## Features

- **Easy-to-use**: MagicTimer offers a simple and intuitive API that allows you to effortlessly manage timers in your iOS apps.
- **Timer Modes**: Choose between two timer modes: Stopwatch and Countdown. Use the Stopwatch mode to measure elapsed time, or Countdown mode to count down from a specified time.
- **Event Handlers**: Take advantage of event handlers to respond to timer state changes and elapsed time updates.
- **Background Time Calculation**: Enable background time calculation to accurately track elapsed time even when the app is in the background.
- **Highly Configurable**: Customize timer properties such as time interval, default value, and effective value to fine-tune your timer behavior.

## Why Use MagicTimer?

- **Saves Development Time**: With MagicTimer, you can quickly integrate timer functionality into your app without spending excessive time on implementation.
- **Flexible Timer Modes**: Whether you need to measure elapsed time or create countdowns, MagicTimer has got you covered.
- **Smooth Background Time Calculation**: Ensure accurate time tracking, even when your app goes into the background.
- **Simplified Event Handling**: Leverage event handlers to handle timer state changes and elapsed time updates effortlessly.
- **Fully Customizable**: Adjust timer properties to match your app's specific requirements.

## Getting Started

To start using the MagicTimer framework in your iOS project, follow these simple steps:

1. Install MagicTimer via Swift Package Manager or by manually adding the framework files to your project.
2. Import the MagicTimer module into your source code files.
3. Create an instance of `MagicTimer` and configure its properties as needed.
4. Set up event handlers to respond to timer state changes and elapsed time updates.
5. Start the timer using the `start()` method.
6. Enjoy the power and convenience of MagicTimer in your app!

### Code Example

```swift
import MagicTimer

// Create an instance of MagicTimer
let timer = MagicTimer()

// Configure the timer properties
timer.countMode = .stopWatch
timer.defultValue = 0
timer.effectiveValue = 1
timer.timeInterval = 1
timer.isActiveInBackground = true

// Set up event handlers
timer.lastStateDidChangeHandler = { state in
    print("Timer state changed: \(state)")
}

timer.elapsedTimeDidChangeHandler = { elapsedTime in
    print("Elapsed time updated: \(elapsedTime)")
}

// Start the timer
timer.start()
```

> **Note:** For detailed usage instructions and API documentation, please refer to the [MagicTimer Documentation](./docs/MagicTimer.md) file.

## Requirements

- iOS 11.0+
- Swift 5.0+

## Installation

### Swift Package Manager

You can use Swift Package Manager to integrate MagicTimer into your Xcode project. Simply add the package dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/MagicTimerFW/MagicTimer", from: "2.0.1")
]
```
### Manual Installation

If you prefer manual installation, you can download the MagicTimer framework from the [GitHub repository](https://github.com/MagicTimerFW/MagicTimer). After downloading, add the necessary files to your Xcode project.

## Warning
⚠️ ```MagicTimerView``` is no longer available. Create your own UIView and connect ```MagicTimer``` to it.

## Contribute

We welcome contributions from the community to enhance the MagicTimer framework. If you encounter any issues or have ideas for improvements, please submit a pull request or open an issue on the [GitHub repository](https://github.com/MagicTimerFW/MagicTimer).

## License

MagicTimer is released under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](./LICENSE) file for more details.

This Markdown file provides an overview of the MagicTimer framework, highlights its features and benefits, guides developers on getting started, provides installation instructions, and encourages contributions. It also includes information on requirements, licensing, and ways to connect
