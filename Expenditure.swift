//
//  Expenditure.swift
//  myMoney
//
//  Created by Мануэль on 21.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

class Expenditure: NSManagedObject
{
    convenience init(Number number: Int) {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entityForName("Expenditure", inManagedObjectContext: context)
        
        let tablePartEntity = NSEntityDescription.entityForName("TablePart", inManagedObjectContext: context)
        
        let tablePart = TablePart(entity: tablePartEntity!, insertIntoManagedObjectContext: context)
        
        tablePart.name = "TablePartArticles"
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.tablePart = tablePart
        self.number    = NSNumber(integer: number)
        self.date      = NSDate()
    }
    
    func addArticleInTablePart(Article article: ArticleString) {
                       
        let table = tablePart?.articles as! NSMutableSet
        
        table.addObject(article)
        
        let set = table as NSSet
        
        tablePart?.articles = set        
    }
    
}
