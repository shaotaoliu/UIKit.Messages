import UIKit
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let scrollView = ChatScrollView()
    private let nameField = ChatTextField(placeholder: "Name...")
    private let emailField = ChatEmailField()
    private let passwordField = ChatPasswordField(placeholder: "Password...")
    private let registerButton = ChatButton(title: "Register")
    private var selectedImage: UIImage? = nil
    private let spinner = JGProgressHUD(style: .dark)

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

        title = "Register"
        view.backgroundColor = .systemBackground
        
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        scrollView.addSubview(userImage)
        scrollView.addSubview(nameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        view.addSubview(scrollView)
        
        userImage.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        userImage.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let imageSize: CGFloat = scrollView.width / 2
        let padding: CGFloat = 30
        let spacing: CGFloat = 20
        
        userImage.frame = CGRect(x: (scrollView.width - imageSize) / 2, y: spacing, width: imageSize, height: imageSize)
        userImage.layer.cornerRadius = userImage.width / 2.0
        
        nameField.frame = CGRect(x: padding,
                                 y: userImage.bottom + spacing * 2,
                                 width: scrollView.width - padding * 2,
                                 height: 50)
        
        emailField.frame = CGRect(x: padding,
                                  y: nameField.bottom + spacing,
                                  width: scrollView.width - padding * 2,
                                  height: 50)
        
        passwordField.frame = CGRect(x: padding,
                                     y: emailField.bottom + spacing,
                                     width: scrollView.width - padding * 2,
                                     height: 50)
        
        registerButton.frame = CGRect(x: padding,
                                   y: passwordField.bottom + spacing,
                                   width: scrollView.width - padding * 2,
                                   height: 50)
    }

    @objc private func register() {
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let name = nameField.text, !name.isEmpty else {
            showErrorMessage(message: "Please enter name.")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            showErrorMessage(message: "Please enter email.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showErrorMessage(message: "Please enter password.")
            return
        }
        
        let user = UserViewModel(name: name, email: email, password: password, image: selectedImage)
        
        spinner.show(in: view)
        
        FirebaseService.shared.signIn(user: user) { error in
            self.spinner.dismiss()
            
            if let error = error {
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            
            self.navigationController?.dismiss(animated: true)
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

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            register()
        }
        
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage.image = selectedImage
            self.selectedImage = selectedImage
        }
    }
}
