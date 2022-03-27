import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    private var myImage: UIImage!
    private var messages = [ChatMessage]()
    var chatter: Chatter!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatter.username

        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
                
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: "SentMessageCell")
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: "ReceivedMessageCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
        
        loadMyPhoto()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if view.frame.origin.y == 0 {
            if let info = notification.userInfo, let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = value.cgRectValue.height
                view.frame.origin.y -= keyboardHeight - 20
            }
        }
    }
    
    @objc func keyboardWillHide(_ notificatin: Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private func loadMyPhoto() {
        let uid = FirebaseService.shared.currentUser!.uid
        FirebaseService.shared.getImage(uid: uid) { image in
            self.myImage = image == nil ? UIImage(systemName: "person.fill") : image!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let uid = FirebaseService.shared.currentUser!.uid
        FirebaseService.shared.getMessages(senderUid: uid, receiverUid: chatter.uid) { messages in
            DispatchQueue.main.async {
                self.messages = messages.sorted { $0.sentDate < $1.sentDate }
                self.tableView.reloadData()
                
                if self.messages.count > 0 {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
        }
        
//        messageTextField.becomeFirstResponder()
    }
    
    @IBAction func sentButtonTapped(_ sender: Any) {
        sendMessage()
    }
    
    private func sendMessage() {
        if let message = messageTextField.text, !message.isEmpty {
            let cm = ChatMessage(id: UUID().uuidString, text: message, sent: true, sentDate: Date())
            let uid = FirebaseService.shared.currentUser!.uid
            
            FirebaseService.shared.storeMessage(senderUid: uid, receiverUid: chatter.uid, message: cm, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    self.messageTextField.text = ""
                }
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.sent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! SentMessageCell
            cell.setPhoto(image: myImage)
            cell.setMessage(message: message)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as! ReceivedMessageCell
        cell.setPhoto(image: chatter.image)
        cell.setMessage(message: message)
        return cell
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
