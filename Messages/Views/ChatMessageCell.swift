import UIKit

class ChatMessageCell: UITableViewCell {

    var photoView = UIImageView()
    var labelMessage = UILabel()
    var bgView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, bgColor: UIColor, flag: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        photoView.layer.cornerRadius = 20
        photoView.layer.masksToBounds = true
        
        bgView.layer.cornerRadius = 6
        bgView.backgroundColor = bgColor
        bgView.addSubview(labelMessage)

        addSubview(bgView)
        addSubview(photoView)

        labelMessage.numberOfLines = 0
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = [
            photoView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            photoView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            photoView.widthAnchor.constraint(equalToConstant: 40),
            photoView.heightAnchor.constraint(equalToConstant: 40),
            
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            bgView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            
            labelMessage.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10),
            labelMessage.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -10),
            labelMessage.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),
            labelMessage.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10)
        ]
        
        if flag {
            constraints.append(contentsOf: [
                photoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
                bgView.trailingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: -5),
                bgView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 50)
            ])
        }
        else {
            constraints.append(contentsOf: [
                photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                bgView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 5),
                bgView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -50)
            ])
        }

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessage(message: ChatMessage) {
        labelMessage.text = message.text
    }
    
    func setPhoto(image: UIImage?) {
        photoView.image = image
    }
    
}
