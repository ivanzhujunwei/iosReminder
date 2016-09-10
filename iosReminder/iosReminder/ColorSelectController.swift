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
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        selectColorDelegate?.selectColor(categoryColors![indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
