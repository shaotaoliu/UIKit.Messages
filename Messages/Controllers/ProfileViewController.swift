import UIKit

class ProfileViewController: UIViewController {
    
    private let nameField = ChatTextField(placeholder: "Name...")
    private let updateButton = ChatButton(title: "Update")
    private var selectedImage: UIImage? = nil
    
    private let userImage: ChatImageView = {
        let image = ChatImageView(systemName: "person.fill")
        image.tintColor = .gray
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        
        view.addSubview(userImage)
        view.addSubview(nameField)
        view.addSubview(updateButton)
        
        userImage.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        userImage.addGestureRecognizer(gesture)
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = view.frame.width / 2
        let padding: CGFloat = 30
        let spacing: CGFloat = 20
        
        userImage.frame = CGRect(x: (view.frame.width - imageSize) / 2, y: 100 + spacing, width: imageSize, height: imageSize)
        
        userImage.layer.cornerRadius = userImage.width / 2.0
        
        nameField.frame = CGRect(x: padding,
                                 y: userImage.bottom + spacing * 2,
                                 width: view.frame.width - padding * 2,
                                 height: 50)
        
        updateButton.frame = CGRect(x: padding,
                                    y: nameField.bottom + spacing,
                                    width: view.frame.width - padding * 2,
                                    height: 50)
    }
    
    func loadData() {
        if let uid = FirebaseService.shared.currentUser?.uid {
            FirebaseService.shared.getImage(uid: uid, completion: { image in
                DispatchQueue.main.async {
                    self.userImage.image = image
                    self.selectedImage = image
                }
            })
            
            FirebaseService.shared.getName(uid: uid, completion: { error, name in
                if let username = name {
                    DispatchQueue.main.async {
                        self.nameField.text = username
                    }
                }
            })
        }
    }
    
    @objc private func update() {
        if let uid = FirebaseService.shared.currentUser?.uid {
            FirebaseService.shared.update(uid: uid, userImage: selectedImage, username: nameField.text)
            
            let alert = UIAlertController(title: "Done", message: "Profile has been updated successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc private func selectImage() {
        let sheet = UIAlertController(title: "Choose Picture", message: "Please select a picture", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .camera)
        }))
        
        sheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        present(sheet, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage.image = selectedImage
            self.selectedImage = selectedImage
        }
    }
}
