//
//  CategoryAddTableController.swift
//  iosReminder
//
//  Created by zjw on 2/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

protocol  AddCategoryDelegate {
    func addCategory(category: Category)
}

class CategoryAddTableController: UITableViewController {

    var managedObjectContext : NSManagedObjectContext?
    var categoryToAdd : Category?
    var addCategoryDelegate: AddCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the added category
        categoryToAdd = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as? Category
    }
    

    @IBAction func addCategory(sender: AnyObject) {
        let sections = numberOfSectionsInTableView(self.tableView)
        for section in 0 ..< sections {
//            let rowCount = tableView.numberOfRowsInSection(section)
            let rowIndex = 0 // every section has only one row
            switch section {
            case 0:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! TextinputTableViewCell
                categoryToAdd?.title = cell.getText()
                break
            case 1:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! CategoryTableViewCell
                categoryToAdd?.location = cell.textDisplayField.text
                break
            case 2:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! CategoryTableViewCell
                categoryToAdd?.radius = Double(cell.radiusDisplayField.text!)
                break
            case 3:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! CategoryTableViewCell
                categoryToAdd?.color = cell.colorDisplayField.text
                break
            case 4:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! ToggleTableViewCell
                if(cell.switchNotify.on){
                    categoryToAdd?.toogle=true
                }else{
                    categoryToAdd?.toogle=false
                }
                break
            default:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! SegementTableViewCell
                
                if(cell.whenSegment.selectedSegmentIndex == 0){// arrive
                    categoryToAdd?.notifyByArriveOrLeave = 0
                }else{
                    categoryToAdd?.notifyByArriveOrLeave = 1
                }
                break
            }
        }
        self.addCategoryDelegate!.addCategory(categoryToAdd!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            print("category")
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryTitleCell", forIndexPath: indexPath) as! TextinputTableViewCell
            cell.categoryTitleText.text = ""
            cell.categoryTitleText.placeholder = "Title"
            return cell
        } else if indexPath.section == 1 {
            print("location")
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! CategoryTableViewCell
            cell.textDisplayField.text = "Caulfield East"
//            cell.textLabel!.text = "Location"
            return cell
        } else if indexPath.section == 2 {
            print("radius")
            let cell = tableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath) as! CategoryTableViewCell
            cell.radiusDisplayField.text = "50"
            return cell
        } else if indexPath.section == 3 {
            print("color")
            let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! CategoryTableViewCell
            cell.colorDisplayField.text = "red"
            return cell
        }else if indexPath.section == 4 {
            print("notify")
            let cell = tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! ToggleTableViewCell
            cell.switchNotify.on = true
            return cell
        } else {
            print("when")
            let cell = tableView.dequeueReusableCellWithIdentifier("whenCell", forIndexPath: indexPath) as! SegementTableViewCell
//            cell.segment
            return cell;
        }
        

        // Configure the cell...

//        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
