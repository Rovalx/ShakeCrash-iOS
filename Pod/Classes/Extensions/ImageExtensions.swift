import UIKit

extension UIImage {
    /// Returns this image with width scaled to given value
    ///
    /// - parameter newWidth: maximum width of photo
    ///
    /// - returns: the same image, but resized to given width
    func resizeImage(newWidth: CGFloat = 600) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
