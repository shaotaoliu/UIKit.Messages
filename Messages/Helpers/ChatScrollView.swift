import UIKit

class ChatScrollView: UIScrollView {
    
    init() {
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
