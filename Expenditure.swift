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
        
        let entity = NSEntityDescription.entity(forEntityName: "Registrator", in: context)
        
        let tablePartEntity = NSEntityDescription.entity(forEntityName: "TablePart", in: context)
        
        let tablePart = TablePart(entity: tablePartEntity!, insertInto: context)
        
        tablePart.name = "TablePartArticles"
        
        self.init(entity: entity!, insertInto: context)
        
        self.name      = Constants.expenditureName
        self.tablePart = tablePart     
        self.date      = Date()
    }
    
    func addArticleInTablePart(Article article: TableString) {
                       
       managedObjectContext?.insert(article)        
    }
      
        
}
