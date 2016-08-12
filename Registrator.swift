//
//  Registrator.swift
//  myMoney
//
//  Created by Мануэль on 12.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class Registrator: NSManagedObject
{

    func conduct() {
        
        _ = RegisterLine(basedOn: self, measure: self.account!, resource: amount!.doubleValue, kind: .Adding, date: NSDate())
        
        try! DataManager.sharedInstance().saveContext()        
    }


}
