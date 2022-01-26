import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupUI(conversation: Conversation) {
        userImage.image = conversation.userImage ?? UIImage(systemName: "person.fill")
        nameLabel.text = conversation.username
        messageLabel.text = conversation.message
    }
}
