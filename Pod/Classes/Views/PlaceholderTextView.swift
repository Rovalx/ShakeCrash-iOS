import UIKit

internal class PlaceholderTextView: UITextView {

	private let placeholderLabel: UILabel = UILabel()

	@IBInspectable var placeholder: String = "" {
		didSet {
			placeholderLabel.text = placeholder
		}
	}

	@IBInspectable var placeholderColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22) {
		didSet {
			placeholderLabel.textColor = placeholderColor
		}
	}

	override var font: UIFont! {
		didSet {
			placeholderLabel.font = font
		}
	}

	override var textAlignment: NSTextAlignment {
		didSet {
			placeholderLabel.textAlignment = textAlignment
		}
	}
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUpInit()
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setUpInit()
	}

	deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UITextView.textDidChangeNotification,
			object: nil)
	}

	private func setUpInit() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
			object: nil)

		// Set placeholder
		placeholderLabel.font = font
		placeholderLabel.textColor = placeholderColor
		placeholderLabel.textAlignment = textAlignment
		placeholderLabel.text = placeholder
		placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
		addSubview(placeholderLabel)
		placeholderLabel.applyLayout(
            .left + textContainer.lineFragmentPadding, .width, .top + textContainerInset.top)
	}

	@objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
	}
}
