//
//  ArticleGroup.swift
//  myMoney
//
//  Created by Мануэль on 29.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class ArticleGroup: NSManagedObject
{
    convenience init(withName name: String) {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entityForName("ArticleGroup", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
    


}
