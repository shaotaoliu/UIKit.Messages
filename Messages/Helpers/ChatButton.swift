import UIKit

class ChatButton: UIButton {
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .link
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.titleLabel?.font = .systemFont(ofSize: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
