//
//  Account+CoreDataProperties.swift
//  myMoney
//
//  Created by Мануэль on 23.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Account
{
    @NSManaged var currency: String
    @NSManaged var name:     String
    @NSManaged var main:     Bool

}
