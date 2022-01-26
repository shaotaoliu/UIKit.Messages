import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {

    private let scrollView = ChatScrollView()
    private let logoImage = ChatImageView(named: "logo")
    private let emailField = ChatEmailField()
    private let passwordField = ChatPasswordField(placeholder: "Password...")
    private let loginButton = ChatButton(title: "Log In")
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Log In"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(register))
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let imageSize: CGFloat = scrollView.width / 2
        let padding: CGFloat = 30
        let spacing: CGFloat = 20
        
        logoImage.frame = CGRect(x: (scrollView.width - imageSize) / 2, y: spacing, width: imageSize, height: imageSize)
        
        emailField.frame = CGRect(x: padding,
                                  y: logoImage.bottom + spacing * 2,
                                  width: scrollView.width - padding * 2,
                                  height: 50)
        
        passwordField.frame = CGRect(x: padding,
                                     y: emailField.bottom + spacing,
                                     width: scrollView.width - padding * 2,
                                     height: 50)
        
        loginButton.frame = CGRect(x: padding,
                                   y: passwordField.bottom + spacing,
                                   width: scrollView.width - padding * 2,
                                   height: 50)
    }
    
    @objc private func register() {
        let controller = RegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func login() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty else {
            showErrorMessage(message: "Please enter email.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showErrorMessage(message: "Please enter password.")
            return
        }
        
        spinner.show(in: view)
        
        FirebaseService.shared.login(email: email, password: password) { error in
            self.spinner.dismiss()
            
            if let error = error {
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            
            self.navigationController?.dismiss(animated: true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            login()
        }
        
        return true
    }
}
