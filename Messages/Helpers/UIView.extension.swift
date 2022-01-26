import UIKit

extension UIView {
    
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
    var left: CGFloat {
        return self.frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
}
