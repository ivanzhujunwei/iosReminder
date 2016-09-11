//
//  RadiusTableViewCell.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// This tableviewCell provides radius cell in CategoryDetailController
class RadiusTableViewCell: UITableViewCell {

    @IBOutlet var radiusDisplayField: UILabel!
    
    // The radius is displayed using String which contains "m", this function get the number from the String
    func getRadiusNumber() -> Int{
        let radiusStr = radiusDisplayField.text?.stringByReplacingOccurrencesOfString("m", withString: "")
        return Int(radiusStr!)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
