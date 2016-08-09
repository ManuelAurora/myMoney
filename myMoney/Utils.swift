//
//  Protocols.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

enum ProcessingModes
{
    case Saving
    case Conduction
}

enum Mode
{
    case Edit
    case New
}

enum DocType
{  
    case Expense
    case Count
}

func fetchData(forEntity entityName: String, withSortKey sort: String) -> [AnyObject] {
    
    let managedContext = DataManager.sharedInstance().context
    
    let fetchRequest = NSFetchRequest(entityName: entityName)
    
    let sortDescr = NSSortDescriptor(key: sort, ascending: false)
    
    fetchRequest.sortDescriptors = [sortDescr]
    
    return try! managedContext.executeFetchRequest(fetchRequest)
}