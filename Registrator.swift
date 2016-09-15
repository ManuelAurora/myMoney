//
//  Registrator.swift
//  myMoney
//
//  Created by Мануэль on 12.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class Registrator: NSManagedObject
{
    
    func conduct() {
        
        if self.name == Constants.expenditureName
        {
            let sum = sumOfDocument()           
            
            _ = RegisterLine(basedOn: self, measure: self.account, resource: sum, kind: .substracting, date: Date())
            
            try! DataManager.sharedInstance().saveContext()
        }
        
        if self.name == Constants.incomeName
        {
            _ = RegisterLine(basedOn: self, measure: self.account, resource: amount!.doubleValue, kind: .adding, date: Date())
            
            try! DataManager.sharedInstance().saveContext()
        }
    }
    
    func sumOfDocument() -> Double {
        
        var sum: Double = 0
        
        if let tablePart = tablePart
        {
            let items = tablePart.tableStrings!.allObjects as! [TableString]
            
            for item in items {
                
                sum += item.price!.doubleValue
            }
        }
        else if let amount = amount
        {
            sum = amount.doubleValue
        }
        
        return sum
    }

    func deleteOldRegisterLine() {
        
        let managedContext = DataManager.sharedInstance().context
        
        let predicate = NSPredicate(format: "registrator=%@", self)
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        if #available(iOS 10.0, *)
        {
            fetchRequest = RegisterLine.fetchRequest()
        }
        else
        {
            fetchRequest = NSFetchRequest(entityName: "RegisterLine")
        }
  
        fetchRequest.predicate = predicate
        
        let result = try! managedContext.fetch(fetchRequest)
        
        for object in result
        {
            managedContext.delete(object as! NSManagedObject)
        }
    }

}
