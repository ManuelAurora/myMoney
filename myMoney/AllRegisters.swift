//
//  Registers.swift
//  myMoney
//
//  Created by Мануэль on 02.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

struct allRegisters
{
    
    static let register = Register()
    
    
    static func conduct(object: Registrator, register: Register) {
        
        let object = object as! Check
        
        var index = 0
        
        if uniqueID(object.ID) {
            for product in object.products {
                
                let registerLine = RegisterLine(registratorID: object.ID, measure: product, resourse: object.prices[index])
                
                register.lines.append(registerLine)
                
                index += 1
                
                print("\(registerLine)")
            }
            
        } else {
            
            
            
            
            
            
            
        }
        
    }
    
    func checkTable(object: Registrator) {
        
        let object = object as! Check
        
        for item in object.products.enumerate() {
            
            
            
            
        }
        
    }
    
//    func findObjectByID(id: Int) -> Registrator{
//        
//      //  let register =
//        
//        for item in register.lines.enumerate() {
//            
//            if item.element.registratorID == id { return item }
//            
//        }
//   
//        
//    }
//    
    
    static func uniqueID(id: Int) -> Bool {
        
        var unique = true
        
        
        for line in allRegisters.register.lines.enumerate() {
            if line.element.registratorID == id {
                unique = false
            }
        }
        return unique
    }
    
    
}