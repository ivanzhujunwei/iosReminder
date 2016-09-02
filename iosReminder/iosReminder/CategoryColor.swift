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
    case Red, Blue
    
    var color:UIColor {
        switch self {
        case .Blue:
            return UIColor.blueColor()
        case .Red:
            return UIColor.redColor()
        }
    }
}