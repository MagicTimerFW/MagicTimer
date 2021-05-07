# MagicTimer

[![Version](https://img.shields.io/cocoapods/v/MagicTimer.svg?style=flat)](https://cocoapods.org/pods/MagicTimer)
[![License](https://img.shields.io/cocoapods/l/MagicTimer.svg?style=flat)](https://cocoapods.org/pods/MagicTimer)
![](https://img.shields.io/badge/Platform-iOS-blue)
[![Gitter](https://badges.gitter.im/MagicTimerCommunity/community.svg)](https://gitter.im/MagicTimerCommunity/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![](https://img.shields.io/badge/IBDesignable-Yes-green)

![MagicTimerLogo](https://user-images.githubusercontent.com/43542836/83555945-53b50780-a524-11ea-850e-d10b0839f63b.png)

MagicTimer is a UIView based timer that displays a countdown or count-up timer.<br/>
![Sample_MagicTimer](https://user-images.githubusercontent.com/43542836/83606033-2bfa8980-a58e-11ea-956e-b57b005f17fa.png)
- [Features](#features)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Documention](#documention), 
  - **Control -** [startCounting](#startCounting), [stopCounting](#stopCounting), [reset](#reset), [resetToDefault](#resetToDefault)
  - **Behavior -** [timeInterval](#timeInterval), [effectiveValue](#effectiveValue), [defaultValue](#defaultValue)
  - **Design -** [Gradient](#gradient), [Border](#border), [CornerRadius](#CornerRadius), [Text](#Text), [Background design](#backgroundDesign )

## Features
- [x] Fully customizable design 
- [x] Support stop watch / count down mode
- [x] Support custom time formatter
- [x] Suppport in background time calculation  
- [x] Modifable time interval / step
- [x] Fully Managable: start, pause, reset
- [x] Available in interface builder or using code
- [x] Support Monospace
- [x] **Easy to use**

## Requirements
- iOS 11.0+
- Swift 5.0+

## Communication

- If you **need help** with magic timer use [Stack Overflow](https://stackoverflow.com/questions/tagged/magictimer) and tag `magictimer`.
- If you **found a bug**, open an issue here on GitHub and follow the guide. The more detail the better!
- If you **want to [contribute](https://github.com/sadeghgoo/MagicTimer/blob/master/CONTRIBUTING.md)**, submit a pull request!


## Installation

### Cocoapod
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website.

You can install Cocoapods with the following command:
```
$ gem install cocoapods
```
To integrate MagicTimer into your Xcode project using CocoaPods, specify it in your `Podfile`.
```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target <'Your target name'> do
    pod 'MagicTimer'
end

```
## Basic Usage

### Interface builder

1. Drag a `UIView` onto your view controller and set the view's class to `MagicTimerView` in the *Identity Inspector*:<br/>
![](https://media.giphy.com/media/lTemQbrtcpq2SXYcuD/giphy.gif)

2. Connect your timer view to your view controller with an `IBOutlet`:<br/>
![](https://media.giphy.com/media/W4QUN133WjUjhRq8RE/giphy.gif)

3. Import MagicTimer to your View Controller
```swift
import MagicTimer
```

3. Call `startCounting` to Begins updates the timer’s display.

### Code

```swift
import MagicTimer

let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
let timer = MagicTimerView(frame: frame)
timer.startCounting() // Begins updates to the timer’s display.
```

## Documention

### MagicTimerView(IBDesignable)

An object that displays a countdown or count-up timer. Use a timer object to configure the amount of time and the appearance of the timer text.
When you start the timer, Magic timer updates the displayed text automatically on the user’s
device without further interactions from your extension.
```swift
open class MagicTimerView : UIView

```

# Control 
Control timer within the below methods.
### `startCounting`
Begins updates to the timer’s display.
```swift
public func startCounting()
```
### `stopCounting`
Stops updates to the timer’s display.
```swift
public func stopCounting()
```
### `reset`
Reset timer to zero.
```swift
public func reset()
```
### `resetToDefault`
Reset timer to the default value.
```swift
public func resetToDefault()
```
### `currentState`
The current state of the timer.
```swift
public var currentState: MGStateManager.TimerState { get }
```
### `mode`
The mode of the timer. default is stop watch.
```swift
public var mode: MGCountMode { get set }
```
### `didStateChange`
A callback that notifies when timer state did change.
```swift
public var didStateChange: ((MGStateManager.TimerState) -> Void)?
```
# Formatter
MagicTimerView can accept custom time formatter. Any time formatter should confrom `MGTimeFormatter`.
### `MGTimeFormatter`
```swift
public protocol MGTimeFormatter
```
Sample custom time formatter
```swift

class CustomTimeFormatter: MGTimeFormatter {
    let dateComponent = DateComponentsFormatter()
    
    init() {
        dateComponent.unitsStyle = .positional
        dateComponent.allowedUnits = [.second]
    }
    func converToValidFormat(ti: TimeInterval) -> String? {
        dateComponent.string(from: ti)
    }
}

```
# Observe 
You can observe elapsed time in two ways. <br />
**First**: using `elapsedTime` property.
```swift
private(set) var elapsedTime: TimeInterval?
```
**Second**: using **Delegate** to observe `elapsedTime` when elapsed time did change.
```swift
protocol MagicTimerViewDelegate: AnyObject {
    func timerElapsedTimeDidChange(timer: MagicTimerView, elapsedTime: TimeInterval)
}
```
# Behavior 
Customize timer behavior within the below properties.
### `timeInterval`
An interval that affects to observing time. Default is 1.
```swift
public var timeInterval: Int { get set }
```
### `effectiveValue`
A value that affects to counting. Default is 1.
```swift
public var effectiveValue: Int { get set }
```
### `defaultValue`
The default value of the timer. The initial value is 0.
```swift
public var defaultValue: Int { get set }
```

# Background mode
### `isActiveInBackground`
A Boolean value that determines whether the calculation of timer active in the background.
```swift
public var isActiveInBackground: Bool { get set }
```
# Design 
## Gradient
Set gradient with a custom angle.
### `startColor(IBInspectable)`
The Start color of the gradient. The default is nil.
```swift
public var startColor: UIColor? { get set }
```
### `endColor(IBInspectable)`
The end color of the gradient. The default is nil.
```swift
public var endColor: UIColor? { get set }
```
### `angle(IBInspectable)`
The angle of the gradient. The default is 270 degrees.
```swift
public var angle: CGFloat { get set }
```

## Border
### `borderColor(IBInspectable)`
The color of the border. Default is clear.
```swift
public var borderColor: UIColor { get set }
```
### `borderWidth(IBInspectable)`
The width of the border. Default is 0.0.
```swift
public var borderWidth: CGFloat { get set }
```

## CornerRadius
### `cornerRadius(IBInspectable)`
The radius to use when drawing rounded corners for the timer view background. Default is 0.0.
```swift
public var cornerRadius: CGFloat { get set }
```
## Text

### `fontSize(IBInspectable)`
Font size of timer label. **Just available in interface builder**.

### `font`
The font used to display the timer label text.
```swift
public var font: UIFont? { get set }
```
### `textColor`
The color of the timer label.
```swift
public var textColor: UIColor! { get set }
```
## BackgroundDesign 
### `backgroundImage`
Background image of the timer. Default is nil.
```swift
public var backgroundImage: UIImage? { get set }

```
## Author
sadegh bitarafan(sadeghgoo), sadeghqbitarafan@gmail.com
## License
MagicTimer is available under the MIT license. See the LICENSE file for more info.
