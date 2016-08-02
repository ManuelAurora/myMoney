//
//  MainObjectThree.swift
//  myMoney
//
//  Created by Мануэль on 02.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

class AllCatalogs
{
 
    let catalogArticle: Catalog = {
       
        let catalog = Catalog(Of: "Article")
        
        return catalog
    }()
    
    let catalogExpenditure: Catalog = {
        
        let catalog = Catalog(Of: "Expenditure")
        
        return catalog
    }()
    
    
    class func sharedInstance() -> AllCatalogs {
        struct Singleton {
            static let sharedInstance = AllCatalogs()
        }
        
        return Singleton.sharedInstance
    }
}

class AllDocuments
{
     let documentsChecksJournal = DocumentsJournal()
    
        class func sharedInstance() -> AllDocuments {
        struct Singleton {
            static let sharedInstance = AllDocuments()
        }
        
        return Singleton.sharedInstance
    }
    
}
