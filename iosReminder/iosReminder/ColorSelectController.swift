//
//  ColorSelectController.swift
//  iosReminder
//
//  Created by zjw on 9/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// Delegate: select a color
protocol  SelectColorDelegate {
    func selectColor(color: CategoryColor)
}

// This viewController provides different colors for choosing
class ColorSelectController: UITableViewController {

    var categoryColors: [CategoryColor]?
    var selectColorDelegate :SelectColorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialise six colors for use
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
        // 1 section in this tableViewController
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The row number of the tableView section is the length of the colors
        return categoryColors!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath)
        let index = indexPath.row
        // To show the color emergency message
        var colorInstruction = ""
        // The first color which is red represents the most emergency among all colors
        if index == 0{
            colorInstruction = " (Emergency)"
        }
        // The last color which is grey represents the least emergency among all colors
        else if index == (categoryColors!.count) - 1 {
            colorInstruction = " (Not Emergency)"
        }
        cell.textLabel?.text = categoryColors![index].rawValue + colorInstruction
        cell.textLabel?.textColor = categoryColors![index].color
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        // Use delegate to choose a color for a category
        selectColorDelegate?.selectColor(categoryColors![indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }

}
