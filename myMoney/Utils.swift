//
//  Protocols.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

enum DocumentPresentationMode
{
    case DocumentEditMode
    case DocumentNewMode
}

enum PopUpElementPresentationMode
{
    case ElementEditMode
    case ElementNewMode
}

enum DocumentType
{  
    case DocumentExpenditureType
}

enum PopUpElementType
{
    case ElementArticleType
    case ElementAccountType
    case ElementAccountListType
}

func fetchData(forEntity entityName: String, withSortKey sort: String?, predicate: NSPredicate?) -> [AnyObject] {
    
    let managedContext = DataManager.sharedInstance().context
    
    let fetchRequest = NSFetchRequest(entityName: entityName)
    
    let sortDescr = NSSortDescriptor(key: sort, ascending: false)
    
    fetchRequest.sortDescriptors = [sortDescr]
    
    if let predicate = predicate
    {
        fetchRequest.predicate = predicate
    }
        
    return try! managedContext.executeFetchRequest(fetchRequest)
}

struct Constants  //RENAME THIS!
{
    static let expenditureName = "Expenditure"
    static let incomeName      = "Income"
}