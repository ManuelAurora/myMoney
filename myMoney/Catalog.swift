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
    
    var items: [AnyObject] = []
    var name:  String = ""
    
    convenience init(Of name: String) {
        self.init()
        
        self.name = name
    }
    
    func allObjects() -> [AnyObject] {
        
        let objects = try! DataManager.sharedInstance().context.executeFetchRequest(NSFetchRequest(entityName: name)) 
        
        return objects
    }
}