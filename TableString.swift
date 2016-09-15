//
//  ArticleString.swift
//  myMoney
//
//  Created by Мануэль on 22.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class TableString: NSManagedObject
{

    convenience init(AddArticle article: Article?, intoTablePart: TablePart?, withPrice: Float?, amount: Float?) {
        
        let context = DataManager.sharedInstance().context
        let entity = NSEntityDescription.entity(forEntityName: "TableString", in: context)
        
        self.init(entity: entity!, insertInto: context)
       
        self.amount    = amount as NSNumber?
        self.price     = withPrice as NSNumber?
        self.tablePart = intoTablePart
        self.article   = article
    }

}
