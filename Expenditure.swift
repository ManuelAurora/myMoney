//
//  Expenditure.swift
//  myMoney
//
//  Created by Мануэль on 21.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

class Expenditure: Registrator
{
    convenience init() {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entityForName("Registrator", inManagedObjectContext: context)
        
        let tablePartEntity = NSEntityDescription.entityForName("TablePart", inManagedObjectContext: context)
        
        let tablePart = TablePart(entity: tablePartEntity!, insertIntoManagedObjectContext: context)
        
        tablePart.name = "TablePartArticles"
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.name      = Constants.expenditureName
        self.tablePart = tablePart     
        self.date      = NSDate()
    }
    
    func addArticleInTablePart(Article article: TableString) {
                       
       managedObjectContext?.insertObject(article)        
    }
      
        
}
