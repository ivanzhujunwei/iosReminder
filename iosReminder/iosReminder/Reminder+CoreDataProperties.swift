//
//  Reminder+CoreDataProperties.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reminder {

    @NSManaged var dueDate: NSDate?
    @NSManaged var note: String?
    @NSManaged var title: String?
    @NSManaged var category: Category?

}
