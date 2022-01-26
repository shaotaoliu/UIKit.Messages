import Foundation
import UIKit

class ConversationViewModel {
    
    var conversations: [Conversation] = []
    
    init() {
        load()
    }
    
    private func load() {
        
    }
    
}

struct Conversation {
    let uid: String
    let username: String
    let message: String
    let userImage: UIImage?
}
