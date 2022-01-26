import UIKit

class SearchUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        userImage.layer.cornerRadius = 20
        userImage.tintColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(user: SearchUserResult) {
        userImage.image = user.image ?? UIImage(systemName: "person.fill")
        nameLabel.text = user.username
    }
}
