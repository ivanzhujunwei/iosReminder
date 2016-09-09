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
    case Red, Orange, Purple, Blue, Green, Grey
    
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
}