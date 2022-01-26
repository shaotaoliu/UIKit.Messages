import UIKit

class ChatTextField: UITextField {
    
    init(placeholder: String, returnKeyType: UIReturnKeyType = .continue) {
        super.init(frame: CGRect.zero)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.placeholder = placeholder
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.leftViewMode = .always
        self.backgroundColor = .secondarySystemBackground
        self.returnKeyType = returnKeyType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
