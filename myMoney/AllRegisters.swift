////
////  Registers.swift
////  myMoney
////
////  Created by Мануэль on 02.06.16.
////  Copyright © 2016 AuroraInterplay. All rights reserved.
////
//
//import Foundation
//
//class allRegisters
//{
//    
//    let register = Register()
//    
//    
//    func conduct(object: Registrator, register: Register) {
//        
//        let object = object as! Expenditure
//                
//        if uniqueID(object.ID) {
//            
//                
//        addNewRecord(object.ID, measure: object.products, resource: object.prices)
//            
//            
//        } else {
//            
//            removeOldInfo(object.ID, inRegister: register)
//            
//            addNewRecord(object.ID, measure: object.products, resource: object.prices)
//            
//        }
//        
//    }
//    
//    private func addNewRecord(objectID: Int, measure: [Measure], resource: [Float]) {
//        
//        for (index, item) in measure.enumerate() {
//            
//            let registerLine = RegisterLine(registratorID: objectID, measure: item, resourse: resource[index])
//            
//            register.lines.append(registerLine)
//        }
//    }
//    
//    private func removeOldInfo(objectId: Int, inRegister register: Register) {
//        
//        for (_,line) in register.lines.enumerate() where line.registratorID == objectId {
//            
//            register.lines.removeFirst()
//            
//        }
//    }
//    
//    private func uniqueID(id: Int) -> Bool {
//        
//        var unique = true
//        
//        
//        for line in register.lines.enumerate() {
//            if line.element.registratorID == id {
//                unique = false
//            }
//        }
//        return unique
//    }
//    
//   class func sharedInstance() -> allRegisters {
//        struct Singletone
//        {
//            static let sharedInstance = allRegisters()
//        }
//        
//        return Singletone.sharedInstance
//    }
//    
//}