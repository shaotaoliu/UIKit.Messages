import UIKit

class ChatPasswordField: ChatTextField {
    
    override init(placeholder: String = "Password...", returnKeyType: UIReturnKeyType = .go) {
        super.init(placeholder: placeholder, returnKeyType: returnKeyType)
        
        self.isSecureTextEntry = true
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
