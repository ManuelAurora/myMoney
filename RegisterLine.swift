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
    convenience init(basedOn registrator: Registrator, measure: Account, resource: Double, kind: RegistratorKind, date: Date) {
        
        let context = DataManager.sharedInstance().context
        let entity = NSEntityDescription.entity(forEntityName: "RegisterLine", in: context)
        
        self.init(entity: entity!, insertInto: context)
        
        self.date        = date
        self.kind        = NSNumber(value: kind.rawValue)
        self.resource    = NSNumber(value: resource)
        self.registrator = registrator
        self.measure     = measure
    }

}

enum RegistratorKind: Int
{
    case substracting = -1
    case adding       =  1
}
