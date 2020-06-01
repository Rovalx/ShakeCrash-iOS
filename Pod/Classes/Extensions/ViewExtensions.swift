import UIKit

internal extension UIView {

    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
		return UINib(
			nibName: nibNamed,
			bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
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
                return UIColor(cgColor: color)
			} else {
                return .clear
			}
		}
		set {
			layer.borderColor = newValue.cgColor
		}
	}
}

internal extension UITextField {

	@IBInspectable var leftPadding: CGFloat {
		get {
			return 0
		}
		set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 1))
            paddingView.backgroundColor = .clear
			self.leftView = paddingView;
            self.leftViewMode = .always
		}
	}
}

internal extension UIButton {

	@IBInspectable var active: Bool {
		get {
            return self.isEnabled
		}
		set {
            self.isEnabled = newValue
			if newValue {
				self.alpha = 1.0
			} else {
				self.alpha = 0.7
			}
		}
	}
}
