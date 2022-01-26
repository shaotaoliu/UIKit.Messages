import UIKit

class ChatImageView: UIImageView {
    
    init(named: String) {
        super.init(image: UIImage(named: named))
        
        self.contentMode = .scaleAspectFit
    }
    
    init(systemName: String) {
        super.init(image: UIImage(systemName: systemName))
        
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
