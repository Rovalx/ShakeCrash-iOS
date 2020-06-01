import UIKit

internal class DrawableView: UIView {

	var lastPath: UIBezierPath
	var previousPoint: CGPoint
	var lineWidth: CGFloat = 2.0
	var pathSet = [UIBezierPath: UIColor]()

    var strokeColor: UIColor = UIColor.red {
		didSet {
			lastPath = UIBezierPath()
			pathSet[lastPath] = strokeColor
		}
	}

	override init(frame: CGRect) {
		previousPoint = CGPoint.zero
		lastPath = UIBezierPath()
		pathSet[lastPath] = strokeColor

		super.init(frame: frame)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(panGestureRecognizer:)))
		panGestureRecognizer.maximumNumberOfTouches = 1
		self.addGestureRecognizer(panGestureRecognizer)
	}

	required init(coder aDecoder: NSCoder) {
		previousPoint = CGPoint.zero
		lastPath = UIBezierPath()
		pathSet[lastPath] = strokeColor

		super.init(coder: aDecoder)!

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(panGestureRecognizer:)))
		panGestureRecognizer.maximumNumberOfTouches = 1
		self.addGestureRecognizer(panGestureRecognizer)
	}

    override func draw(_ rect: CGRect) {
		// Drawing code
		for (path, color) in pathSet.reversed() {
			color.setStroke()
			path.stroke()
			path.lineWidth = lineWidth
		}
	}

	@objc func pan(panGestureRecognizer: UIPanGestureRecognizer) -> Void {
        let currentPoint = panGestureRecognizer.location(in: self)
        let midPoint = self.midPoint(p0: previousPoint, p1: currentPoint)

        if panGestureRecognizer.state == .began {
            lastPath.move(to: currentPoint)
        } else if panGestureRecognizer.state == .changed {
            lastPath.addQuadCurve(to: midPoint, controlPoint: previousPoint)
		}

		previousPoint = currentPoint
		self.setNeedsDisplay()
	}

	func midPoint(p0: CGPoint, p1: CGPoint) -> CGPoint {
		let x = (p0.x + p1.x) / 2
		let y = (p0.y + p1.y) / 2
		return CGPoint(x: x, y: y)
	}
}
