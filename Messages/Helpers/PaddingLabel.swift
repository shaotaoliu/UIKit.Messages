import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    
    @IBInspectable var topPadding: CGFloat = 0
    @IBInspectable var bottomPadding: CGFloat = 0
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftPadding + rightPadding,
                      height: size.height + topPadding + bottomPadding)
    }

}
