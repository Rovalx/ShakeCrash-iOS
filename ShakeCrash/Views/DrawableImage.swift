import UIKit

class DrawableView: UIView {

	var lastPath: UIBezierPath
	var previousPoint: CGPoint
	var lineWidth: CGFloat = 2.0
	var pathSet = [UIBezierPath: UIColor]()

	var strokeColor: UIColor = UIColor.redColor() {
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

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
		panGestureRecognizer.maximumNumberOfTouches = 1
		self.addGestureRecognizer(panGestureRecognizer)
	}

	required init(coder aDecoder: NSCoder) {
		previousPoint = CGPoint.zero
		lastPath = UIBezierPath()
		pathSet[lastPath] = strokeColor

		super.init(coder: aDecoder)!

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
		panGestureRecognizer.maximumNumberOfTouches = 1
		self.addGestureRecognizer(panGestureRecognizer)
	}

	override func drawRect(rect: CGRect) {
		// Drawing code
		for (path, color) in pathSet.reverse() {
			color.setStroke()
			path.stroke()
			path.lineWidth = lineWidth
		}
	}

	func pan(panGestureRecognizer: UIPanGestureRecognizer) -> Void {
		let currentPoint = panGestureRecognizer.locationInView(self)
		let midPoint = self.midPoint(previousPoint, p1: currentPoint)

		if panGestureRecognizer.state == .Began {
			lastPath.moveToPoint(currentPoint)
		} else if panGestureRecognizer.state == .Changed {
			lastPath.addQuadCurveToPoint(midPoint, controlPoint: previousPoint)
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
