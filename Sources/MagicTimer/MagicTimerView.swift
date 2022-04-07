import Foundation
import UIKit

/**
 An  object that displays a countdown or count-up timer.
 
 Use a timer object to configure the amount of time and the appearance of the timer text.
 When you start the timer, Magic timer updates the displayed text automatically on the user’s
 device without further interactions from your extension.
 */

@IBDesignable
open class MagicTimerView: UIView {
    
    /// Timer broker that bridge between timer logic and view.
    private var broker: MagicTimer = .init()
    /// Formatter that format time interval to string.
    public var formatter: MGTimeFormatter = MGStandardTimerFormatter()
    /// Elappsed time of timer.
    private(set) var elapsedTime: TimeInterval?

    public weak var delegate: MagicTimerViewDelegate?
    
    /// The current state of the timer.
    public var currentState: MagicTimerState {
        return broker.currentState
    }
    /// Timer state callback
    public var didStateChange: ((MagicTimerState) -> Void)?

    /// The color of the timer label.
    @IBInspectable public var textColor: UIColor! {
        willSet {
            timerLabel.textColor = newValue
        }
    }
    
    /// Font size of timer label. just available in interface builder. Default value is 18.
    @available(*, unavailable, message: "Just available in interface builder")
    @IBInspectable var fontSize: CGFloat = 18 {
        willSet {
            timerLabel.font = timerLabel.font.withSize(newValue)
        }
    }
        
    /// The radius to use when drawing rounded corners for the timer view background. Default is 0.0.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        willSet {
            layer.cornerRadius = newValue
        }
    }
    /// The color of the border. Default is clear.
    @IBInspectable public var borderColor: UIColor = .clear {
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }
    /// The width of the border. Default is 0.0.
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        willSet {
            layer.borderWidth = newValue
        }
    }
    
    /// The Start color of the gradient. The default is nil.
    @IBInspectable public var gradeintStartColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    /// The end color of the gradient. The default is nil.
    @IBInspectable public var gradeintEndColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    /// The angle of the gradient. The default is 270 degrees.
    @IBInspectable public var gradeintAngle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }
    /// Background image of the timer. Default is nil.
    public var backgroundImage: UIImage? {
        willSet {
            let isHidden = newValue != nil ? false: true
            backgrounImageView.isHidden = isHidden
            backgrounImageView.image = newValue
        }
    }
    /// A value that affects to counting. Default is 1.
    @IBInspectable public var effectiveValue: Int = 1 {
        willSet {
            let validTimeInterval = newValue.convertToTimeInterval()
            broker.effectiveValue = validTimeInterval
        }
    }
    /// An interval that affects to observing time. Default is 1.
    @IBInspectable public var timeInterval: Int = 1 {
        willSet {
            let validTImeInterval = newValue.convertToTimeInterval()
            broker.timeInterval = validTImeInterval
        }
    }
    /// The default value of the timer. The initial value is 0.
    @IBInspectable public var defaultValue: Int = 0 {
        willSet {
            broker.defultValue = newValue.convertToTimeInterval()
            let validTimeInterval = newValue.convertToTimeInterval()
            timerLabel.text = formatter.converToValidFormat(ti: validTimeInterval)
        }
    }
    
    /// A Boolean value that determines whether the calculation of timer active in background.
    @IBInspectable public var isActiveInBackground: Bool = false {
        willSet {
            broker.isActiveInBackground = newValue
        }
    }
    /// The font used to display the timer label text.
    public var font: UIFont? {
        willSet {
            timerLabel.font = newValue?.monospacedDigitFont
        }
    }
    /// The mode of the timer. default is stop watch.
    public var mode: MGCountMode = .stopWatch {
        willSet {
            broker.countMode = newValue
        }
    }
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18).monospacedDigitFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backgrounImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSubView()
        setConstraint()
        observeTime()
        setInitialValue()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSubView()
        setConstraint()
        observeTime()
        setInitialValue()
        
    }
    /// Set inital value to interface object. Called when interface is initialized.
    private func setInitialValue() {
        timerLabel.text = formatter.converToValidFormat(ti: 0)
        
    }
    /// Called when interface is initialized. Override this method for conforming delegate.
    func observeTime() {
        broker.observeElapsedTime = { timeInterval in
            self.elapsedTime = timeInterval
            DispatchQueue.main.async {
                self.timerLabel.text = self.formatter.converToValidFormat(ti: timeInterval)
                self.delegate?.timerElapsedTimeDidChange(timer: self, elapsedTime: timeInterval)
            }
        }
    }
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [gradeintStartColor?.cgColor ?? UIColor.clear.cgColor, gradeintEndColor?.cgColor ?? UIColor.clear.cgColor]
        (layer as! CAGradientLayer).cornerRadius = cornerRadius
    }
    
    private func updateGradient() {
        let grLayer = layer as? CAGradientLayer
        if let gradient = grLayer {
            let startColor = self.gradeintStartColor ?? UIColor.clear
            let endColor = self.gradeintEndColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.gradeintAngle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }
    
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    /// Begins updates to the timer’s display.
    public func startCounting() {
        broker.start()
        didStateChange?(.fired)
    }
    
    /// Stops updates to the timer’s display.
    public func stopCounting() {
        broker.stop()
        didStateChange?(.stopped)

    }
    
    /// Reset timer to zero.
    public func reset() {
        timerLabel.text = formatter.converToValidFormat(ti: 0)
        broker.reset()
        didStateChange?(.restarted)
    }
    /// Reset timer to the default value.
    public func resetToDefault() {
        timerLabel.text = formatter.converToValidFormat(ti: broker.defultValue)
        broker.resetToDefault()
        didStateChange?(.restarted)
    }
    
}

extension MagicTimerView: StandardConstraintableView {
    
    /// Set constraint of any element in object.  Called in init after initialSubView method.
    func setConstraint() {
        
        let timerLabelConstraint: [NSLayoutConstraint] = [
            timerLabel.topAnchor.constraint(equalTo: topAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        let imageViewConstrinat: [NSLayoutConstraint] = [
            backgrounImageView.topAnchor.constraint(equalTo: topAnchor),
            backgrounImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgrounImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgrounImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstrinat)
        NSLayoutConstraint.activate(timerLabelConstraint)
    }
    
    /// Add subview of any element in object. Called in init before setConstraint method.
    func initialSubView() {
        addSubview(backgrounImageView)
        addSubview(timerLabel)
    }
    
}



