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
 
    var catalogArticle: Catalog {
       
        let catalog = Catalog(Of: "Article")
        
        return catalog
    }
    
    var catalogExpenditure: Catalog {
        
        let catalog = Catalog(Of: "Registrator")
        
        return catalog
    }
    
    var catalogArticleGroups: Catalog {
        
        let catalog = Catalog(Of: "ArticleGroup")
        
        return catalog
    }
    
    
    class func sharedInstance() -> AllCatalogs {
        struct Singleton {
            static let sharedInstance = AllCatalogs()
        }
        
        return Singleton.sharedInstance
    }   
}
