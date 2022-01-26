import UIKit

class ChatEmailField: ChatTextField {
    
    init(returnKeyType: UIReturnKeyType = .continue) {
        super.init(placeholder: "Email Address...", returnKeyType: returnKeyType)
        
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
