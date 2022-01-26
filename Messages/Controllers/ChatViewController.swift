import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    private var myImage: UIImage!
    var chatter: Chatter!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyData()
        setupInputButton()
    }
    
    private func loadMyData() {
        let uid = FirebaseService.shared.currentUser!.uid
        FirebaseService.shared.getImage(uid: uid) { image in
            self.myImage = image == nil ? UIImage(systemName: "person.fill") : image!
        }
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            //self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
//    private func presentInputActionSheet() {
//        let actionSheet = UIAlertController(title: "Attach Media",
//                                            message: "What would you like to attach?",
//                                            preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
//            self?.presentPhotoInputActionsheet()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
//            self?.presentVideoInputActionsheet()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in
//
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [weak self]  _ in
//            self?.presentLocationPicker()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(actionSheet, animated: true)
//    }
    
    
    
}
