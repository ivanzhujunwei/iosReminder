//
//  CategoryAnnotation.swift
//  Custom annotation which contains the catgory information
//  iosReminder
//
//  Created by zjw on 7/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import MapKit

// This is a custom annotaion which has category attribute
// When annotations are generated, category information is stored inside
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
    
    // assemble catogry's information with the annotation
    func assembleCategoryInfo(category: Category){
        self.setCoordinate(category.getCoordinate())
        self.title = category.getAnnotationPopupTitle()
        self.catgory = category
    }
}