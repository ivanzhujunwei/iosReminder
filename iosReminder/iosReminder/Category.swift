//
//  Category.swift
//  iosReminder
//
//  Created by zjw on 31/08/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Category: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
//    func addReminder(reminder:Reminder) {
//        self.reminders?.allObjects.
//    }
    func getAnnotationPopupTitle() -> String{
        return self.title! + " " + String(self.radius!) + "m"
    }
    
    func getRadius() -> Double{
        return Double(self.radius!)
    }
    
    // return display information for "radius"
    func displayRadius() -> String{
        // convert to Int first to remove the zero after the decimal point, then convert to string
        return String(Int(getRadius())) + "m"
    }
    
    func getLongitude() -> Double{
        return Double(self.longitude!)
    }
    
    func getLatitude() -> Double{
        return Double(self.latitude!)
    }
    
    func getCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongitude())
    }
    
    // get how many reminders are imcomplete in this category
    func getInCompleteReminderCount() -> Int{
        var incompleteReminderCount = 0
        for reminder in self.reminders!{
            let rem = reminder as! Reminder
            if (!Bool(rem.completed!)){
              incompleteReminderCount += 1
            }
        }
        return incompleteReminderCount
    }
    
    func generateNotifyMessage() -> String{
        var message = ""
        if self.notifyByArriveOrLeave == 0 {
            message = "You have arrived at "
        }else {
            message = "You are leaving from "
        }
        message += self.location! + ", "
        message += String(getInCompleteReminderCount()) + " reminders need to be completed."
        return message
    }
    
    
    
}
