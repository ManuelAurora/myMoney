//
//  Catalog.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

class Catalog {
    
    var name:  String = ""
    
    convenience init(Of name: String) {
        self.init()
        
        self.name = name
    }
    
    func allObjects() -> [NSManagedObject] {
        
        let articles = try! DataManager.sharedInstance().context.executeFetchRequest(NSFetchRequest(entityName: name)) as! [NSManagedObject]
        
        return articles
    }
    
    func objectsFiltered(by predicate: NSPredicate) -> [NSManagedObject] {

        let fetchRequest = NSFetchRequest(entityName: name)
        
        fetchRequest.predicate = predicate
        
        let articles = try! DataManager.sharedInstance().context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        
        return articles        
    }
}