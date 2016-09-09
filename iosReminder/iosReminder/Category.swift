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
    
    func getLongitude() -> Double{
        return Double(self.longitude!)
    }
    
    func getLatitude() -> Double{
        return Double(self.latitude!)
    }
    
    func getCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongitude())
    }
}
