//
//  Income.swift
//  myMoney
//
//  Created by Мануэль on 27.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class Income: Registrator
{

    convenience init(withAmount amount: Double) {
        
        let context = DataManager.sharedInstance().context
        
        let entity = NSEntityDescription.entity(forEntityName: "Registrator", in: context)
                
        self.init(entity: entity!, insertInto: context)
      
        self.date   = Date()
        self.amount = amount as NSNumber?
        self.name   = Constants.incomeName
    }   
    
}
