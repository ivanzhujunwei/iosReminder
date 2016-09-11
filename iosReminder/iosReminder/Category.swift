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

    // Return the annotation title when tapping a annotation
    func getAnnotationPopupTitle() -> String{
        return self.title! + " " + String(self.radius!) + "m"
    }
    
    // Return the catgory's radius in double format
    func getRadius() -> Double{
        return Double(self.radius!)
    }
    
    // Return display information for "radius"
    func displayRadius() -> String{
        // Convert to Int first to remove the zero after the decimal point, then convert to string
        return String(Int(getRadius())) + "m"
    }
    
    // Return category's longitude in double format
    func getLongitude() -> Double{
        return Double(self.longitude!)
    }
    
    // Return category's latitude in double format
    func getLatitude() -> Double{
        return Double(self.latitude!)
    }
    
    // Return category's coordinate
    func getCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongitude())
    }
    
    // Return how many reminders are imcomplete in this category
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
    
    // Return the pop up message when user has arrived or leaved a region
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
