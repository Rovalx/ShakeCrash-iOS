import UIKit

extension UIView {

	class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
		return UINib(
			nibName: nibNamed,
			bundle: bundle
		).instantiateWithOwner(nil, options: nil)[0] as? UIView
	}

	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}

	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable var borderColor: UIColor {
		get {
			if let color = layer.borderColor {
				return UIColor(CGColor: color)
			} else {
				return UIColor.clearColor()
			}
		}
		set {
			layer.borderColor = newValue.CGColor
		}
	}
}

extension UITextField {

	@IBInspectable var leftPadding: CGFloat {
		get {
			return 0
		}
		set {
			let paddingView = UIView(frame: CGRectMake(0, 0, newValue, 1))
			paddingView.backgroundColor = UIColor.clearColor()
			self.leftView = paddingView;
			self.leftViewMode = UITextFieldViewMode.Always;
		}
	}
}

extension UIButton {

	@IBInspectable var active: Bool {
		get {
			return self.enabled
		}
		set {
			self.enabled = newValue
			if newValue {
				self.alpha = 1.0
			} else {
				self.alpha = 0.7
			}
		}
	}
}