import UIKit
import Firebase

class CheckViewController: UIViewController {
    
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var tax: UILabel!
    
    @IBOutlet weak var finalTotal: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let subTotalPriceText = totalPrice.text,
            let total:String = String(format: "%.2f", UserDefaults.standard.double(forKey: "total"))  {
            totalPrice.text = subTotalPriceText + total
        }
        
        if let taxText = totalPrice.text {
            let numberFormatter = NumberFormatter()
            let totalPrice = numberFormatter.number(from: taxText)?.doubleValue
            let taxAmt:Double = totalPrice! * 0.085
            tax.text = String(format: "%.2f", taxAmt)
        }
        
        if let finalTotalText = totalPrice.text {
            let numberFormatter = NumberFormatter()
            let totalPrice = numberFormatter.number(from: finalTotalText)?.doubleValue
            let finalPrice:Double = totalPrice! * 1.085
            finalTotal.text = String(format: "%.2f", finalPrice)
        }
    }

    @IBAction func confirmButon(_ sender: Any) {
        // check whether use fill in their info of profile
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            // user could check out if profile has enough info
            if (value?["name"] as? String ?? "" != ""  &&
                value?["address"] as? String ?? "" != "" &&
                value?["phone"] as? String ?? "" != "") {
                
                self.performSegue(withIdentifier: "Successful", sender: self)
                
            } else {
                let alertController = UIAlertController(title: "Oops!", message: "Please complete Profile, we coule contact to you. Go to Profile -> Edit.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        // Remove the list when user click cancel button
        
        // go back to root view controller
        self.navigationController?.popToRootViewController(animated: true)
    }
}
