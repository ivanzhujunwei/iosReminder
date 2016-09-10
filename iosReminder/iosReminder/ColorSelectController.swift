//
//  ColorSelectController.swift
//  iosReminder
//
//  Created by zjw on 9/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

protocol  SelectColorDelegate {
    func selectColor(color: CategoryColor)
}

class ColorSelectController: UITableViewController {

    var categoryColors: [CategoryColor]?
    var uiColors:NSArray?
    var selectColorDelegate :SelectColorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryColors = [CategoryColor.Red,
                      CategoryColor.Orange,
                      CategoryColor.Purple,
                      CategoryColor.Blue,
                      CategoryColor.Green,
                      CategoryColor.Grey]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryColors!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath)
        let index = indexPath.row
        var colorInstruction = ""
        if index == 0{
            colorInstruction = " (Emergency)"
        } else if index == (categoryColors!.count) - 1 {
            colorInstruction = " (Not Emergency)"
        }
        cell.textLabel?.text = categoryColors![indexPath.row].rawValue + colorInstruction
        cell.textLabel?.textColor = categoryColors![indexPath.row].color
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        selectColorDelegate?.selectColor(categoryColors![indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }

}
