//
//  TextinputTableViewCell.swift
//  iosReminder
//
//  Created by zjw on 2/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class TextinputTableViewCell: UITableViewCell {

    @IBOutlet var categoryTitleText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getText()->String{
        return categoryTitleText.text!
    }
}
