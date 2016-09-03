//
//  ToggleTableViewCell.swift
//  iosReminder
//
//  Created by zjw on 3/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {

    @IBOutlet var switchNotify: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
