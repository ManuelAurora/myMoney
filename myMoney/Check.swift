//
//  Check.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

class Check: Registrator, Document
{
    var products  = [Expenditure]()
    var prices    = [Float]()
    let date      = NSDate()
    
    var sum:       Int = 0
    var number:    Int = 0
    
    let operation: String = "Check"
    
    func addProduct(product: Expenditure) {
        products.append(product)
    }
    
    func addPrice(price: Float) {
        
        prices.append(price)
    }
    
    func conduct(register: Register) {
        
        var index = 0
        
        for product in products {
            
            let registerLine = RegisterLine(registrator: self, measure: product, resourse: prices[index])
            
            register.lines.append(registerLine)
            
            index += 1
        }
    }        
    
    func sumOfCheck() -> Int {
        
        for product in products.enumerate() {
            sum += Int(self.prices[product.index])
        }
        
         return sum
    }
    
    
}