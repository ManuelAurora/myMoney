//
//  RegisterLine.swift
//  myMoney
//
//  Created by Мануэль on 10.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData


class RegisterLine: NSManagedObject
{
    convenience init(basedOn registrator: Registrator, measure: Account, resource: Double, kind: RegistratorKind, date: NSDate) {
        
        let context = DataManager.sharedInstance().context
        let entity = NSEntityDescription.entityForName("RegisterLine", inManagedObjectContext: context)
        
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.date        = date
        self.kind        = kind.rawValue
        self.resource    = resource
        self.registrator = registrator
        self.measure     = measure
    }

}

enum RegistratorKind: Int
{
    case Substracting = -1
    case Adding       =  1
}
