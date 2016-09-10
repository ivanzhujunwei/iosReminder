//
//  ReminderListController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class ReminderListController: UITableViewController, AddReminderDelegate {
    
    var categoryToView: Category!
    var reminderList: [Reminder]!
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Q: create a new NSArray or the reference of previou object
//        reminders = categoryToView.reminders?.allObjects
        getSortedReminders()
        tableView.tableFooterView = UIView()
    }

    func getSortedReminders(){
        let completedReminderSort = NSSortDescriptor (key:"completed", ascending:true)
        let dueDateReminderSort = NSSortDescriptor (key:"dueDate", ascending: false)
        let reminderSorts = [completedReminderSort,dueDateReminderSort]
        reminderList = categoryToView.reminders?.sortedArrayUsingDescriptors(reminderSorts) as! [Reminder]
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
        case 1: return (reminderList?.count)!
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryBriefCell", forIndexPath: indexPath)
            cell.textLabel?.text = categoryToView.title
            cell.detailTextLabel?.text = categoryToView.location
            cell.textLabel?.textColor = CategoryColor(rawValue: categoryToView!.color!)?.color
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
            let reminder: Reminder = reminderList[indexPath.row]
            cell.textLabel?.text = reminder.title
            if isRedReminder(reminder) {
                cell.textLabel?.textColor = UIColor.redColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            return cell
        }
    }
    
    // There are 2 conditions when a reminder should display in red
    // #1: the reminder is over due
    // #2: the reminder is not completed
    func isRedReminder(reminder: Reminder) -> Bool{
        let currentDate = NSDate()
        let compare = reminder.dueDate?.compare(currentDate)
        // if the reminder is due
        if compare == NSComparisonResult.OrderedAscending && !Bool(reminder.completed!) {
            return true
        }else {
            return false
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
        getSortedReminders()
        self.tableView.reloadData()
    }
    
    func addReminder(reminder: Reminder) {
//        let newIndexPath = NSIndexPath(forRow: categoryToView.reminders!.count, inSection: 1)
        let newSet = NSMutableSet(set: categoryToView.reminders!)
        newSet.addObject(reminder)
        categoryToView.reminders = newSet
//        categoryList.append(category)
//        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        do{
            try managedObjectContext!.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addReminderSegue" {
            let addReminderController = segue.destinationViewController as! ReminderAddController
            addReminderController.managedObjectContext = self.managedObjectContext
            addReminderController.currentCategory = self.categoryToView
            addReminderController.addReminderDelegate = self
            
        } else if segue.identifier == "editCategorySegue" {
            let editCategoryController = segue.destinationViewController as! CategoryAddTableController
            editCategoryController.managedObjectContext = self.managedObjectContext
            editCategoryController.category = self.categoryToView
            
        } else if segue.identifier == "viewReminderSegue" {
            let viewReminderController = segue.destinationViewController as! ReminderAddController
            let indexPath = tableView.indexPathForSelectedRow
            viewReminderController.reminder = reminderList[indexPath!.row]
            viewReminderController.currentCategory = self.categoryToView
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
            // Delete the row from the data source
            if editingStyle == .Delete {
                let reminder = reminderList![indexPath.row] as NSManagedObject
                // Delete the reminder from sorted array
                reminderList.removeAtIndex(indexPath.row)
                // Delete the object from object context
                managedObjectContext!.deleteObject(reminder)
                // Delete the reminder from the category
                let newSet = NSMutableSet(set: categoryToView.reminders!)
                newSet.removeObject(reminder)
                categoryToView.reminders = newSet
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

    // TODO: TODOLIST
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
