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
        
        loadMyPhoto()
    }
    
    private func loadMyPhoto() {
        let uid = FirebaseService.shared.currentUser!.uid
        FirebaseService.shared.getImage(uid: uid) { image in
            self.myImage = image == nil ? UIImage(systemName: "person.fill") : image!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let uid = FirebaseService.shared.currentUser!.uid
//        FirebaseService.shared.getMessages(senderUid: uid, receiverUid: chatter.uid) { messages in
//            self.messages = messages
//            
//
//        }
        
        messageTextField.becomeFirstResponder()
    }
    
    var sent = true
    @IBAction func sentButtonTapped(_ sender: Any) {
        sendMessage()
    }
    
    private func sendMessage() {
        if let message = messageTextField.text, !message.isEmpty {
            let cm = ChatMessage(id: UUID().uuidString, text: message, sent: sent, sentDate: Date())
            messages.append(cm)
            sent.toggle()
            tableView.reloadData()
            messageTextField.text = ""
        }
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
