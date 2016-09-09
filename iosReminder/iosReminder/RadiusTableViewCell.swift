//
//  RadiusTableViewCell.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class RadiusTableViewCell: UITableViewCell {

    @IBOutlet var radiusDisplayField: UILabel!
//    @IBOutlet var radiusPicker: UIPickerView!
//    var radiuses: [String]?
    
    // CGFloat: The basic type for floating-point scalar values in Core Graphics and related frameworks
//    @IBOutlet var ddd: UIDatePicker!
//    @IBOutlet var datepcker: UIDatePicker!
//    @IBOutlet var datepicker: UIDatePicker!
//    let expandedHeight: CGFloat = 200
//    let defaultHeight: CGFloat = 44
    
//    required init?(coder aDecoder: NSCoder) {
//
//    }
    
//    func checkHeight(){
//        radiusPicker.hidden = frame.size.height < self.expandedHeight
//    }
    
    // the radius is displayed using String which contains "m", this function get the number from the String
    func getRadiusNumber() -> Int{
        let radiusStr = radiusDisplayField.text?.stringByReplacingOccurrencesOfString("m", withString: "")
        return Int(radiusStr!)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.radiusPicker.dataSource = self
//        self.radiusPicker.delegate = self
//         radiuses = ["50m","250m","1000m"]
//        UIpicker
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
