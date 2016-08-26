//
//  RegisterLine+CoreDataProperties.swift
//  myMoney
//
//  Created by Мануэль on 12.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RegisterLine {

    @NSManaged var date: NSDate
    @NSManaged var kind: NSNumber
    @NSManaged var resource: NSNumber 
    @NSManaged var registrator: NSManagedObject?
    @NSManaged var measure: Account?

}
