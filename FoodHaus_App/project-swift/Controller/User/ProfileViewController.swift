import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    var user: Users!
    
    // define references to database
    let ref = Database.database().reference()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = Users(authData: user)
        }
        
        // retrieve current user's info from database
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // get user value
            let value = snapshot.value as? NSDictionary
            self.nameLabel.text = value?["name"] as? String ?? ""
            self.emailLabel.text = value?["email"] as? String ?? ""
            self.addressLabel.text = value?["address"] as? String ?? ""
            self.phoneLabel.text = value?["phone"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editButton(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileToEdit", sender: self)
    }
}
