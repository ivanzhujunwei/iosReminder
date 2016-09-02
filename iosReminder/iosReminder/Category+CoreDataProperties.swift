//
//  Category+CoreDataProperties.swift
//  iosReminder
//
//  Created by zjw on 2/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var color: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var notifyByArriveOrLeave: NSNumber?
    @NSManaged var radius: NSNumber?
    @NSManaged var title: String?
    @NSManaged var toogle: NSNumber?
    @NSManaged var location: String?
    @NSManaged var reminders: NSSet?

}
