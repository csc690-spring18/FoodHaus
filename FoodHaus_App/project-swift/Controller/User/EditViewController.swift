import UIKit
import FirebaseDatabase
import FirebaseAuth

class EditViewController: UIViewController {
    var user: Users!
    
    // define references to DB
    let ref = Database.database().reference()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = Users(authData: user)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        // save data into Database as json
        let email = self.user.getEmail
        guard
            let name = nameTextField.text,
            let phone = phoneTextField.text,
            let address = addressTextField.text
        else {
            return
        }
        
        // user has to fill in all info in their profile
        if (name != "" && address != "" && phone != "") {
            self.ref.child("users").child(user.getUid).setValue(["email": email,
                                                                 "name": name,
                                                                 "phone": phone,
                                                                 "address": address])
     
            dismiss(animated: true, completion: nil)
            
        } else {
            //Tells the user that they need to fill in all info
            let alertController = UIAlertController(title: "Oops", message: "Please fill in all information so that we could contact and delivery to you", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
