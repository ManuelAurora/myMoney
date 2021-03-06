//
//  Article.swift
//  myMoney
//
//  Created by Мануэль on 21.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class Article: NSManagedObject
{
    convenience init(named name: String) {
        
        let context = DataManager.sharedInstance().context
        let entity = NSEntityDescription.entity(forEntityName: "Article", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        self.name = name
        
        }

}
