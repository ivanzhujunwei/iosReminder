//
//  CategoryColor.swift
//  iosReminder
//
//  Created by zjw on 1/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import UIKit

enum CategoryColor : String{
    
    // Color enum
    case Red, Orange, Purple, Blue, Green, Grey
    
    // Different enum color variable represent diffent UIColor().
    var color : UIColor {
        switch self {
        case .Red:
            return UIColor.redColor()
        case .Blue:
            return UIColor.blueColor()
        case .Orange:
            return UIColor.orangeColor()
        case .Purple:
            return UIColor.purpleColor()
        case .Green:
            return UIColor.greenColor()
        case .Grey:
            return UIColor.lightGrayColor()
        }
    }
    
    // Different color represents different priority.
    // Low number represents high priority.
    // Categories with high priority will display on the top of other categories with low priority.
    var priority: Int{
        switch self {
        case .Red:
            return 0
        case .Orange:
            return 1
        case .Purple:
            return 3
        case .Blue:
            return 2
        case .Green:
            return 4
        case .Grey:
            return 5
        }
    }
}