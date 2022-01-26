import UIKit

class ChatViewController: UIViewController {
    
    private var myImage: UIImage!
    var chatter: Chatter!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadMyData()
    }
    
    private func loadMyData() {
        let uid = FirebaseService.shared.currentUser!.uid
        FirebaseService.shared.getImage(uid: uid) { image in
            self.myImage = image == nil ? UIImage(systemName: "person.fill") : image!
        }
    }
    
}
