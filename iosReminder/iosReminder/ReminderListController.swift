//
//  ReminderListController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class ReminderListController: UITableViewController {
    
    var categoryToView: Category!
    var reminders: NSArray!
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Q: create a new NSArray or the reference of previou object
        reminders = categoryToView.reminders?.allObjects
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return (categoryToView.reminders?.count)!
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryBriefCell", forIndexPath: indexPath)
            cell.textLabel?.text = categoryToView.title
            cell.detailTextLabel?.text = categoryToView.location
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
            let rlist = categoryToView.reminders?.allObjects
            let reminder: Reminder = rlist![indexPath.row] as! Reminder
            cell.textLabel?.text = reminder.title
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addReminderSegue" {
            let addReminderController = segue.destinationViewController as! ReminderAddController
            addReminderController.managedObjectContext = self.managedObjectContext
            addReminderController.currentCategory = self.categoryToView
        } else if segue.identifier == "editCategorySegue" {
            let editCategoryController = segue.destinationViewController as! CategoryAddTableController
            editCategoryController.managedObjectContext = self.managedObjectContext
            editCategoryController.category = self.categoryToView
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if( indexPath.section == 1){
            if editingStyle == .Delete {
                // Delete the row from the data source
                let rlist = categoryToView.reminders?.allObjects
                managedObjectContext!.deleteObject(rlist![indexPath.row] as! NSManagedObject)
                
//                categoryToView.reminders?.delete(<#T##sender: AnyObject?##AnyObject?#>)
//                categoryToView.reminders?.allObjects.removeAtIndex(indexPath)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                // save the managedObjectContext
                do{
                    try self.managedObjectContext!.save()
                }catch let error {
                    print("Could not save reminder Deletion \(error)")
                }
            }
        }
    }

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