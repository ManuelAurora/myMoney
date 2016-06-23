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
                       
       managedObjectContext?.insertObject(article)        
    }
    
    func removeArticleInTablePart(Article article: ArticleString) {
        
        managedObjectContext?.deleteObject(article)
    }
    
    func editObject(OldVersion object: ArticleString, newVersion: ArticleString) {
        
        let table = tablePart?.articleStrings as! NSMutableSet

        table.removeObject(object)
        
        table.addObject(newVersion)
    }
    
    func sumOfDocument() -> Float {
        
        let items = tablePart!.articleStrings!.allObjects as! [ArticleString]
        
        var sum: Float = 0
        
        for item in items {
            
            sum += item.price!.floatValue
        }
        
        return sum
    }
    
}
