//
//  CheckViewController.swift
//  project-swift
//
//  Created by Bo Li on 4/19/18.
//  Copyright © 2018 Bo Li. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var productTypeArr:[String] = []
    var productNameArr:[AnyObject] = []
    var productPriceArr:[AnyObject] = []   // Price
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FoodHaus"
        self.view.backgroundColor = UIColor.white
        self.initData()
        self.automaticallyAdjustsScrollViewInsets = false
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
}
