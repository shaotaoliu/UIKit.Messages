import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    @IBOutlet weak var chatterTable: UITableView!
    private let vm = ConversationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        
        chatterTable.delegate = self
        chatterTable.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseService.shared.currentUser == nil {
            gotoLoginScreen()
            return
        }
        
        vm.loadConversation {
            DispatchQueue.main.async {
                self.chatterTable.reloadData()
            }
        }
    }

    @objc private func signOut() {
        FirebaseService.shared.signOut()
        gotoLoginScreen()
    }
    
    @objc private func compose() {
        let vc = NewChatViewController(nibName: "NewChatViewController", bundle: nil)
        vc.completion = { result in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.chatter = Chatter(uid: result.uid, username: result.username, image: result.image)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    private func gotoLoginScreen() {
        let controller = LoginViewController()
        let navController = UINavigationController(rootViewController: controller)
    
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: false)
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as! ConversationTableViewCell
        cell.setupUI(conversation: vm.conversations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let conv = vm.conversations[indexPath.row]
        vc.chatter = Chatter(uid: conv.uid, username: conv.username!, image: conv.userImage)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
