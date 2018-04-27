import UIKit
import Firebase

class ConfirmViewController: UIViewController {
    @IBAction func BackToMenuButton(_ sender: Any) {    // Can't go back to main menu
        self.navigationController?.popToRootViewController(animated: true)
    }
}
