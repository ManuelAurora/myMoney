//
//  TablePart+CoreDataProperties.swift
//  myMoney
//
//  Created by Мануэль on 27.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TablePart {

    @NSManaged var name: String?
    @NSManaged var tableStrings: NSSet?
    @NSManaged var expenditure: Expenditure?
    

}
