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
    
    func getName(uid: String, completion: @escaping (String) -> Void) {
        database.child("users/\(uid)/username").getData { error, snapshot in
            if error != nil {
                completion("Error")
                return
            }
            
            completion(snapshot.value as? String ?? "Unknown")
        }
    }
    
    func storeMessage(user: UserViewModel, completion: @escaping (Error?) -> Void) {
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
    
    
    
    func storeMessage(senderUid: String, receiverUid: String, message: ChatMessage, completion: @escaping (Error?) -> Void) {
        
        database.child("messages").child("\(senderUid)\(receiverUid)").child("messages").setValue([
            "text": message.text,
            "sent": true,
            "sentDt": Date().timeIntervalSince1970
        ])
        
        database.child("messages").child("\(receiverUid)\(senderUid)").child("messages").setValue([
            "text": message.text,
            "sent": false,
            "sentDt": Date().timeIntervalSince1970
        ])
    }

}




