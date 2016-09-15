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
        
        let articles = try! DataManager.sharedInstance().context.fetch(NSFetchRequest(entityName: name)) 
        
        return articles as! [NSManagedObject]
    }
    
    func objectsFiltered(by predicate: NSPredicate) -> [NSManagedObject] {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        fetchRequest.predicate = predicate
        
        let articles = try! DataManager.sharedInstance().context.fetch(fetchRequest) as! [NSManagedObject]
        
        return articles        
    }
}
