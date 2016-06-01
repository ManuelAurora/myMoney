//
//  Product.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

class Expenditure: Measure
{
    var name: String
    
    var useQuantityAndPrice = false
    
    var parent: Expenditure?
    
    init(name: String) {
        
        self.name  = name
        
    }
    
    
}