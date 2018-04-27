import UIKit
import Firebase

class MenuViewController: UIViewController {
    var productTypeArr:[String] = []
    var productNameArr:[AnyObject] = []
    var productPriceArr:[AnyObject] = []   // Price
//    var login: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FoodHaus"
        self.view.backgroundColor = UIColor.white
        self.initData()
        self.automaticallyAdjustsScrollViewInsets = false
        
//        if (login) {
//            self.navigationItem.leftBarButtonItem =
//                UIBarButtonItem(title: "Log out", style: .plain, target: self, action: nil)
//        } else {
//            self.navigationItem.leftBarButtonItem =
//                UIBarButtonItem(
//                    title: "Log in", style: .plain, target: self, action: nil)
//        }

    }
    
    func  initData()
    {
        // Product Name
        let path:String = (Bundle.main.path(forResource: "MenuData", ofType: "json"))!
        let data:Data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json:AnyObject = try!JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
        let resultDict = json.object(forKey: "data") as! Dictionary<String,AnyObject>
        let productMenuArr:[AnyObject] = resultDict["productType"] as! Array
        
        for i:Int in 0 ..< productMenuArr.count
        {
            productTypeArr.append(productMenuArr[i]["typeName"] as! String)
            productNameArr.append(productMenuArr[i]["productName"] as! [AnyObject] as AnyObject)
        }
        
        // Product Price
        let pricePath:String = (Bundle.main.path(forResource: "MenuPrice", ofType: "json"))!
        let priceData:Data = try! Data(contentsOf: URL(fileURLWithPath: pricePath))
        let priceJson:AnyObject = try!JSONSerialization.jsonObject(with: priceData, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
        let priceResultDict = priceJson.object(forKey: "data") as! Dictionary<String,AnyObject>
        let priceProductMenuArr:[AnyObject] = priceResultDict["productType"] as! Array
        
        for i:Int in 0 ..< priceProductMenuArr.count
        {
            productPriceArr.append(priceProductMenuArr[i]["productPrice"] as! [AnyObject] as AnyObject)
        }
        
        self.addSubView()
        self.addSubViewPrice()
    }
    
    func addSubView(){
        let classifyTable = GroupTableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        self.view.addSubview(classifyTable)
    }
    
    func addSubViewPrice(){
        let classifyTable = GroupTableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        self.view.addSubview(classifyTable)
    }
    
    
    
    @IBAction func CheckButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "MenuToCheck", sender: self)

        } else {
            let alertController = UIAlertController(title: "Oops!", message: "You have to Log in", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func userButton(_ sender: UIButton) {
        // check whether user has valid auth session Firebase

        if Auth.auth().currentUser != nil {

            // user log out
//            login = false;
            
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            let alertController = UIAlertController(title: "Log out", message: "Your account has been logged out", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            


        } else { // cur user logged out
//            login = true
            self.performSegue(withIdentifier: "MenuToLogin", sender: self)

        }


        
        /* Need help!!! */
        
//        if (self.navigationItem.leftBarButtonItem?.title == "Login") {  // cur user logged in
//
//
//            self.navigationItem.leftBarButtonItem?.title = "Log out"
//        } else if (self.navigationItem.leftBarButtonItem?.title == "Log out") { // cur user logged out
//
//            
//            self.navigationItem.leftBarButtonItem?.title = "Login"
//
//        }
    }
    
}
