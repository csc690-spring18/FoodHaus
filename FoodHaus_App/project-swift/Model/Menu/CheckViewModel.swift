//
//  CheckTableModel.swift
//  project-swift
//
//  Created by Tyler Evans on 4/22/18.
//  Copyright © 2018 Bo Li. All rights reserved.
//

import UIKit

struct List {
    var name: String
    var price: Double
}

class CheckViewModel
{
    
    var item: [List]
    
    init() {
        item = []
    }
    
    func addItem( name: String, price: Double ) {   // add food with price into array
        self.item.append( List( name: name, price: price))
    }
    
    var itemValue: [List] {
        get {
            return item
        }
    }
    
}
