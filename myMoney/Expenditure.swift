//
//  Product.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

class Expenditure: NSManagedObject, Measure
{
    @NSManaged var name: String
    
    var useQuantityAndPrice = false
    
    var parent: Expenditure?
    
    
    init(name: String) {
        
        let managedContext = DataManager.sharedInstance().managedObjectContext
        let entity = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedContext )

        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        self.name  = name        
    }
    
    
}