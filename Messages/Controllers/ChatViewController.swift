import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    private var myImage: UIImage!
    var chatter: Chatter!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatter.username
        loadMyData()
        setupMessageInputBar()
    }
    
    private func loadMyData() {
        let uid = FirebaseService.shared.currentUser!.uid
        FirebaseService.shared.getImage(uid: uid) { image in
            self.myImage = image == nil ? UIImage(systemName: "person.fill") : image!
        }
    }
    
    private func setupMessageInputBar() {
//        let button = InputBarButtonItem()
//        button.setSize(CGSize(width: 35, height: 35), animated: false)
//        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
//
//        button.onTouchUpInside { [weak self] _ in
//            self?.presentInputActionSheet()
//        }
        
//        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
//        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)

        messageInputBar.inputTextView.layer.backgroundColor = CGColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        messageInputBar.inputTextView.layer.cornerRadius = 5
        messageInputBar.becomeFirstResponder()
    }
    
//    private func presentInputActionSheet() {
//
//        let actionSheet = UIAlertController(title: "Attach Image",
//                                            message: "Please attach an image",
//                                            preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(actionSheet, animated: true)
//    }
//
//    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = self
//        picker.allowsEditing = true
//        self.present(picker, animated: true)
//    }
}
