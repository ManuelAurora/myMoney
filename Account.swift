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
        
        self.name = name
    }
    
    func accountBalance() -> Double {
        
        let predicate = NSPredicate(format: "measure = %@", self)
        
        let result = fetchData(forEntity: "RegisterLine", withSortKey: "date", predicate: predicate)
        
        var sum: Double = 0
        
        for item in result
        {
            let regLine = item as! RegisterLine
                        
            let value   = regLine.resource!.doubleValue * regLine.kind!.doubleValue
            
            sum += value
        }
        
        return sum
    }
}
