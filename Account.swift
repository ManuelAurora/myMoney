//
//  Count.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class Account: NSManagedObject
{
    convenience init(withName name: String) {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entityForName("Account", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.main = false
        
        self.name = name
    }
    
    func accountBalance() -> Double {
        
        let predicate = NSPredicate(format: "measure = %@", self)
        
        let result = DataManager.sharedInstance().fetchData(forEntity: "RegisterLine", withSortKey: "date", predicates: [predicate])
        
        var sum: Double = 0
        
        for item in result
        {
            let regLine = item as! RegisterLine
                        
            let value   = regLine.resource.doubleValue * regLine.kind.doubleValue
            
            sum += value
        }
        
        return sum
    }
    
    func makeMain() {
        
        let predicate        = NSPredicate(format: "main=%@",  true)
        let notSelfPredicate = NSPredicate(format: "name!=%@", self.name)
        
        let allAccounts = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: nil, predicates: [predicate, notSelfPredicate]) as! [Account]
        
        allAccounts.first?.main = false
        
        self.main = true
    }
    
    class func mainAccount() -> Account {
        
        let predicate        = NSPredicate(format: "main=%@",  true)       
        
        let allAccounts = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: nil, predicates: [predicate]) as! [Account]
        
        return allAccounts.first!
    }
    
    class func isFirstAccount() -> Bool {
        
        let result = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: nil, predicates: nil)
        
        return result.count == 0
    }
    
    
}
