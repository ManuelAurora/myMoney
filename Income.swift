//
//  Income.swift
//  myMoney
//
//  Created by Мануэль on 27.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class Income: NSManagedObject
{

    convenience init(withAmount amount: Double) {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entityForName("Income", inManagedObjectContext: context)
                
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
      
        self.date   = NSDate()
        self.amount = amount
    }
    
}
