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
    
    var items: [Article] = []
    var name:  String = ""
    
    convenience init(Of name: String) {
        self.init()
        
        self.name = name
    }
    
    func allObjects() -> [Article] {
        
        let articles = try! DataManager.sharedInstance().context.executeFetchRequest(NSFetchRequest(entityName: name)) as! [Article]
        
        return articles
    }
}