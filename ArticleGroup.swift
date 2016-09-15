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
        
        let entity = NSEntityDescription.entity(forEntityName: "ArticleGroup", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        self.name = name
    }
    


}
