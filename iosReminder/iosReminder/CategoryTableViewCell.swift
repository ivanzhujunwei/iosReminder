//
//  CategoryTableViewCell.swift
//  iosReminder
//
//  Created by zjw on 30/08/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

//    @IBOutlet var textDisplayField: UILabel!
    @IBOutlet var radiusDisplayField: UILabel!
    @IBOutlet var colorDisplayField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
