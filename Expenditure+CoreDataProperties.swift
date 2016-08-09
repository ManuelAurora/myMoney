//
//  Expenditure+CoreDataProperties.swift
//  myMoney
//
//  Created by Мануэль on 09.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Expenditure {

    @NSManaged var date: NSDate?
    @NSManaged var tablePart: TablePart?
    @NSManaged var account: Account?

}
