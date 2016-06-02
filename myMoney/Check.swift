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
    var mode: Mode
    var ID: Int
    
    var sum:       Int = 0
    var number:    Int = 0
    
    let operation: String = "Check"
    
    init(mode: Mode) {
        
        self.mode = mode
        
        ID = self.number + Int(arc4random())
    }
    
    
    func addProduct(product: Expenditure) {
        products.append(product)
    }
    
    func addPrice(price: Float) {
        
        prices.append(price)
    }
    
    func conduct() {
        
       allRegisters.conduct(self, register: allRegisters.register)
    }        
    
    func sumOfCheck() -> Int {
        
        for product in products.enumerate() {
            sum += Int(self.prices[product.index])
        }
        
         return sum
    }
    
    
}

enum Mode {
    case New
    case Edit(Int?)
}