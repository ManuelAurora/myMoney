
//  DataManager.swift
//  myMoney
//
//  Created by Мануэль on 04.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager
{    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func saveEntity(object: NSManagedObject) {
        
        try! managedObjectContext.save()       
    }
    
    func fetchData() -> [AnyObject] {
        let fetchRequest = NSFetchRequest(entityName: "Article")
        
        let result = try! managedObjectContext.executeFetchRequest(fetchRequest)
        
        return result
    }
       
    
    class func sharedInstance() -> DataManager {
        struct Singleton {
            static let sharedInstance = DataManager()
        }
        
        return Singleton.sharedInstance
    }
}
