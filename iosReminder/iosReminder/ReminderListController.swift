//
//  ReminderListController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

//  This viewController diplays a category and its all related reminders in order
class ReminderListController: UITableViewController, AddReminderDelegate {
    
    // The category which is being viewed
    var categoryToView: Category!
    // The category's reminder list
    var reminderList: [Reminder]!
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialise reminders in order
        reminderList = getSortedReminders()
        // Delete blank rows
        tableView.tableFooterView = UIView()
    }

    // Return sorted reminders, two factors affect the sort result
    // #1: Firstly, sorted by 'completed' state, completed reminders will display at the bottom of list
    // #2: Secondly, sorted by 'dueDate' value in descending order
    func getSortedReminders() -> [Reminder]{
        let completedReminderSort = NSSortDescriptor (key:"completed", ascending:true)
        let dueDateReminderSort = NSSortDescriptor (key:"dueDate", ascending: false)
        let reminderSorts = [completedReminderSort,dueDateReminderSort]
        return categoryToView.reminders?.sortedArrayUsingDescriptors(reminderSorts) as! [Reminder]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
            // First and second section has only 1 row
            case 0: return 1
            case 1: return 1
            // Second section's row number is the length of reminderList
            case 2: return (reminderList?.count)!
            default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // For first section
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryBriefCell", forIndexPath: indexPath)
            // Configure cell's values
            cell.textLabel?.text = categoryToView.title
//            cell.detailTextLabel?.text = categoryToView.location
            cell.textLabel?.textColor = CategoryColor(rawValue: categoryToView!.color!)?.color
            return cell
        }
            // For second section
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryInfoCell", forIndexPath: indexPath)
            // Configure cell's values
            let incompleteReminders = categoryToView.getInCompleteReminderCount()
            // If there is no reminder needed to be complete, display 'All done'
            if incompleteReminders == 0{
                cell.textLabel?.text = "All done"
                // If there are some other reminders remained to be completed, then display the message
            }else{
                cell.textLabel?.text = String(categoryToView.getInCompleteReminderCount()) + " reminder not completed at " + categoryToView.location!
            }
            return cell
        }
            // For third section
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
            // Configure cell's values
            let reminder: Reminder = reminderList[indexPath.row]
            // If the reminder is completed, mark attached
            if Bool(reminder.completed!){
                cell.textLabel?.text = "✓ " + reminder.title!
            }else{
                cell.textLabel?.text = reminder.title!
            }
            if isRedReminder(reminder) {
                cell.textLabel?.textColor = UIColor.redColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Only the reminders section can has edit support
        if indexPath.section == 2{
            return true
        }
        return false
    }
    
    // There are 2 conditions when a reminder should display in red
    // #1: the reminder is over due
    // #2: the reminder is not completed
    func isRedReminder(reminder: Reminder) -> Bool{
        let currentDate = NSDate()
        let compare = reminder.dueDate?.compare(currentDate)
        // if the reminder is due and not completed
        if compare == NSComparisonResult.OrderedAscending && !Bool(reminder.completed!) {
            return true
        }else {
            return false
        }
    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        // Set the foot height for first section
//        if section == 0 || section == 1{
//            return 20
//        }
//        return 0
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Resort the reminders
        reminderList = getSortedReminders()
        self.tableView.reloadData()
        // Update monitored regions
        NSNotificationCenter.defaultCenter().postNotificationName("updateMonitoredRegionsNotifyId", object: nil)
//        updateMonitoredCategoryRegions()
    }
    
    // Update monitored regions
//    func updateMonitoredCategoryRegions(){
//        let mapAnotationController = self.tabBarController?.viewControllers![1].childViewControllers[0] as! CategoryMapAnnotationController
//        mapAnotationController.updateMonitoredRegions()
//    }

    // Delegate: add a reminder
    func addReminder(reminder: Reminder) {
        // Get current remidners
        let newSet = NSMutableSet(set: categoryToView.reminders!)
        newSet.addObject(reminder)
        // Reset the categoryToView's reminders
        categoryToView.reminders = newSet
        do{
            try managedObjectContext!.save()
            self.tableView.reloadData()
        }catch{
            fatalError("Failure to save context: \(error)")
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // When adding a reminder, ReminderAddController is going to be displayed
        if segue.identifier == "addReminderSegue" {
            let addReminderController = segue.destinationViewController as! ReminderAddController
            addReminderController.managedObjectContext = self.managedObjectContext
            // Pass current viewing category to ReminderAddController
            addReminderController.currentCategory = self.categoryToView
            addReminderController.addReminderDelegate = self
        }
        // When editing a category, CategoryAddTableController is going to be displayed
        else if segue.identifier == "editCategorySegue" {
            let editCategoryController = segue.destinationViewController as! CategoryAddTableController
            editCategoryController.managedObjectContext = self.managedObjectContext
            // Pass current viewing category to CategoryAddTableController
            editCategoryController.category = self.categoryToView
        }
        // When editing a reminder, ReminderAddController is going to be displayed
        else if segue.identifier == "viewReminderSegue" {
            let viewReminderController = segue.destinationViewController as! ReminderAddController
            let indexPath = tableView.indexPathForSelectedRow
            viewReminderController.managedObjectContext = self.managedObjectContext
            // Get the selected reminder and pass it to destination ViewController
            viewReminderController.reminder = reminderList[indexPath!.row]
            // Pass current viewing category to ReminderAddController
            viewReminderController.currentCategory = self.categoryToView
        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if( indexPath.section == 2){
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
                do{
                    // save the managedObjectContext
                    try self.managedObjectContext!.save()
                    self.tableView.reloadData()
                    // Update monitored regions
                    NSNotificationCenter.defaultCenter().postNotificationName("updateMonitoredRegionsNotifyId", object: nil)
//                    updateMonitoredCategoryRegions()
                }catch let error {
                    print("Could not save reminder Deletion \(error)")
                }
            }
        }
    }

}
