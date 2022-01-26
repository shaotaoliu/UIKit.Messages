import UIKit

extension UIViewController {
    
    func showErrorMessage(title: String = "Error", message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(controller, animated: true)
    }
    
}
