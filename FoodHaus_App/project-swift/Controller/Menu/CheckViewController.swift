import UIKit
import Firebase

class CustomCell: UITableViewCell {
    
}

class CheckViewController: UIViewController {
    
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let items = UserDefaults.standard.stringArray(forKey: "Name") ?? [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "OurCustomCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let subTotalPriceText = subTotalPrice.text!
        let subTotal:String = String(format: "%.2f", UserDefaults.standard.double(forKey: "total"))
        subTotalPrice.text = subTotalPriceText + subTotal
        
        if let taxText = subTotalPrice.text {
            let numberFormatter = NumberFormatter()
            let totalPrice = numberFormatter.number(from: taxText)?.doubleValue
            let taxAmt:Double = totalPrice! * 0.085
            tax.text = String(format: "%.2f", taxAmt)
        }
        
        if let totalPriceText = subTotalPrice.text {
            let numberFormatter = NumberFormatter()
            let total = numberFormatter.number(from: totalPriceText)?.doubleValue
            let afterTax:Double = total! * 1.085
            totalPrice.text = String(format: "%.2f", afterTax)
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
                
                // check whether user selected any items
                if self.subTotalPrice.text == "0.00" {
                    let alertController = UIAlertController(title: "Oops!", message: "Please order something!", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    self.resetPrice()
                    self.resetItem()
                    UserDefaults.standard.set(true, forKey: "init")
                    
                    self.performSegue(withIdentifier: "Successful", sender: self)
                }
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
        self.resetPrice()
        self.resetItem()
        UserDefaults.standard.set(true, forKey: "init")
        // go back to root view controller
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // reset data of subtotal
    func resetPrice() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "total")
        }
    }
    
    // reset data of item
    func resetItem() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "Name")
        }
    }
}

extension CheckViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OurCustomCell") ?? UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
