import Foundation
import UIKit

class ConversationViewModel {
    
    var conversations: [Conversation] = []
    
    func loadConversation(completion: @escaping () -> Void ) {
        if let uid = FirebaseService.shared.currentUser?.uid {
            FirebaseService.shared.getLatestMessages(uid: uid, completion: { conversations in
                self.conversations = conversations
                completion()
            })
        }
    }
    
}

struct Conversation {
    let uid: String
    let username: String?
    let message: String
    let userImage: UIImage?
}
