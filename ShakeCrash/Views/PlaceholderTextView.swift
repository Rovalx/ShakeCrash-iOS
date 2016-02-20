import Foundation

import UIKit

class PlaceholderTextView: UITextView {

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

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUpInit()
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setUpInit()
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self,
			name: UITextViewTextDidChangeNotification,
			object: nil)
	}

	private func setUpInit() {

		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: "textDidChange",
			name: UITextViewTextDidChangeNotification,
			object: nil)

		// Set placeholder

		placeholderLabel.font = font
		placeholderLabel.textColor = placeholderColor
		placeholderLabel.textAlignment = textAlignment
		placeholderLabel.text = placeholder
		placeholderLabel.numberOfLines = 0
		placeholderLabel.backgroundColor = UIColor.clearColor()
		addSubview(placeholderLabel)
		placeholderLabel.applyLayout(
				.Left() + textContainer.lineFragmentPadding, .Width(), .Top() + textContainerInset.top)
	}

	func textDidChange() {
		placeholderLabel.hidden = !text.isEmpty
	}
}