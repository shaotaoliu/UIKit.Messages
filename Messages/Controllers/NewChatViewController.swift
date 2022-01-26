import UIKit

class NewChatViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchedUsers: [SearchUserResult] = []
    private var filteredUsers: [SearchUserResult] {
        var users = searchedUsers
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            users = searchedUsers.filter {
                $0.username.localizedCaseInsensitiveContains(searchText)
            }
        }

        return users.sorted {
            $0.username < $1.username
        }
    }
    
    var completion: ((SearchUserResult) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        let nib = UINib(nibName: "SearchUserTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchUserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
    private func loadData() {
        FirebaseService.shared.getAllUsers { result in
            self.searchedUsers = result
            self.tableView.reloadData()
        }
    }

    @objc func cancel() {
        dismiss(animated: true)
    }
}

extension NewChatViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTableViewCell", for: indexPath) as! SearchUserTableViewCell
        cell.setupUI(user: filteredUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        dismiss(animated: false) {
            self.completion?(self.filteredUsers[indexPath.row])
        }
    }
}
