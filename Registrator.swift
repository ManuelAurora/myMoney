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
            
            _ = RegisterLine(basedOn: self, measure: self.account, resource: sum, kind: .Substracting, date: NSDate())
            
            try! DataManager.sharedInstance().saveContext()
        }
        
        if self.name == Constants.incomeName
        {
            _ = RegisterLine(basedOn: self, measure: self.account, resource: amount!.doubleValue, kind: .Adding, date: NSDate())
            
            try! DataManager.sharedInstance().saveContext()
        }
    }
    
    func sumOfDocument() -> Double {
        
        guard let tablePart = tablePart else { return 0 }
        
        let items = tablePart.tableStrings!.allObjects as! [TableString]
                
        var sum: Double = 0
        
        for item in items {
            
            sum += item.price!.doubleValue
        }
        
        return sum
    }

    func deleteOldRegisterLine() {
        
        let managedContext = DataManager.sharedInstance().context
        
        let predicate = NSPredicate(format: "registrator=%@", self)
        let fetchRequest = NSFetchRequest(entityName: "RegisterLine")
  
        fetchRequest.predicate = predicate
        
        let result = try! managedContext.executeFetchRequest(fetchRequest)
        
        for object in result
        {
            managedContext.deleteObject(object as! NSManagedObject)
        }
    }
    

}
