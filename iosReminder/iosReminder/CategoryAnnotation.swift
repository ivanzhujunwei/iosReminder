//
//  CategoryAnnotation.swift
//  iosReminder
//
//  Created by zjw on 7/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import MapKit

class CategoryAnnotation: NSObject, MKAnnotation{
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var title: String?
    var subtitle: String?

    var catgory:Category?
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}