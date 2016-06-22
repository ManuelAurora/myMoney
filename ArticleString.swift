//
//  ArticleString.swift
//  myMoney
//
//  Created by Мануэль on 22.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class ArticleString: NSManagedObject
{

    convenience init(AddArticle article: Article, intoTablePart: TablePart?, withPrice: Float?, amount: Float?) {
        
        let context = DataManager.sharedInstance().context
        let entity = NSEntityDescription.entityForName("ArticleString", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
       
        self.amount    = amount
        self.price     = withPrice
        self.tablePart = intoTablePart
        self.article   = article
    }

}
