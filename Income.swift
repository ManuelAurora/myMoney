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

    convenience init(Number number: Int) {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entityForName("Income", inManagedObjectContext: context)
        
        let tablePartEntity = NSEntityDescription.entityForName("TablePart", inManagedObjectContext: context)
        
        let tablePart = TablePart(entity: tablePartEntity!, insertIntoManagedObjectContext: context)
        
        tablePart.name = "TablePartArticles"
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.tablePart = tablePart
        self.date      = NSDate()
    }
    
}
