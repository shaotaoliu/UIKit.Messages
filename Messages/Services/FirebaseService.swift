import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class FirebaseService {
    static let shared = FirebaseService()
    private let auth = FirebaseAuth.Auth.auth()
    private let database = Database.database().reference()
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    var currentUser: User? {
        auth.currentUser
    }
    
    func signIn(user: UserViewModel, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            let uid = result!.user.uid
            
            self.database.child("users").child(uid).setValue([
                "username": user.name
            ])
            
            if let image = user.image, let data = image.pngData() {
                self.storage.child("images").child(uid).putData(data, metadata: nil)
            }
            
            completion(nil)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func signOut() {
        try! auth.signOut()
    }
    
    func getAllUsers(completion: @escaping ([SearchUserResult]) -> Void) {
        database.child("users").observe(.value) { snapshot in
            let dic = snapshot.value as! [String : [String : String]]
            var result = [SearchUserResult]()
            
            for (key, value) in dic {
                self.getImage(uid: key) { image in
                    result.append(SearchUserResult(uid: key, username: value["username"]!, image: image))
                    
                    if (result.count == dic.count) {
                        completion(result)
                    }
                }
            }
        }
    }
    
    func getImage(uid: String, completion: @escaping (UIImage?) -> Void) {
        self.storage.child("images").child(uid).getData(maxSize: 1024 * 1024 * 5) { data, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func getName(uid: String, completion: @escaping (Error?, String?) -> Void) {
        database.child("users").child(uid).observe(.value) { snapshot in
            let dic = snapshot.value as! [String : Any]
            let name = dic["username"] as! String
            
            completion(nil, name)
        }
    }
    
    func getMessages(senderUid: String, receiverUid: String, completion: @escaping ([ChatMessage]) -> Void) {
        database.child("messages").child("\(senderUid)\(receiverUid)").child("messages").observe(.value, with: { snapshot in
            var messages = [ChatMessage]()
            
            if let dic = snapshot.value as? [String : [String : Any]] {
                for (key, value) in dic {
                    let text = value["text"] as! String
                    let sent = value["sent"] as! Bool
                    let sentDt = value["sentDt"] as! TimeInterval
                    
                    messages.append(ChatMessage(id: key, text: text, sent: sent, sentDate: Date(timeIntervalSince1970: sentDt)))
                }
            }
            
            completion(messages)
        })
    }
    
    func storeMessage(senderUid: String, receiverUid: String, message: ChatMessage, completion: @escaping (Error?) -> Void) {
        
        database.child("messages").child("\(senderUid)\(receiverUid)").child("messages").child(message.id).setValue([
            "text": message.text,
            "sent": true,
            "sentDt": message.sentDate.timeIntervalSince1970
        ])
        
        database.child("messages").child("\(receiverUid)\(senderUid)").child("messages").child(message.id).setValue([
            "text": message.text,
            "sent": false,
            "sentDt": message.sentDate.timeIntervalSince1970
        ])
        
        getName(uid: senderUid, completion: { error, name in
            if let error = error {
                completion(error)
                return
            }
            
            if let name = name {
                self.database.child("latestMessages").child(senderUid).child(receiverUid).setValue([
                    "sender": name,
                    "text": message.text,
                    "sentDt": message.sentDate.timeIntervalSince1970
                ])
                
                self.database.child("latestMessages").child(receiverUid).child(senderUid).setValue([
                    "sender": name,
                    "text": message.text,
                    "sentDt": message.sentDate.timeIntervalSince1970
                ])
                
                completion(nil)
            }
        })
    }

    func getLatestMessages(uid: String, completion: @escaping ([Conversation]) -> Void) {
        database.child("latestMessages").child(uid).observe(.value, with: { snapshot in
            var conversations = [Conversation]()
            
            if let dic = snapshot.value as? [String : [String : Any]] {
                var count = 0
                
                for (key, value) in dic {
                    let username = value["sender"] as? String ?? nil
                    let message = value["text"] as! String
                    
                    self.getImage(uid: key, completion: { image in
                        conversations.append(Conversation(uid: key, username: username, message: message, userImage: image))
                        count += 1
                        
                        if count == dic.count {
                            completion(conversations)
                        }
                    })
                }
            }
        })
    }
    
    func update(uid: String, userImage: UIImage?, username: String?) {
        
        if let name = username, !name.isEmpty {
            self.database.child("users").child(uid).setValue([
                "username": name
            ])
        }
        
        if let image = userImage, let data = image.pngData() {
            self.storage.child("images").child(uid).putData(data, metadata: nil)
        }
    }
}
