//
//  CategoryViewController.swift
//  iosReminder
//
//  Created by zjw on 30/08/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryList : [Category]!
    var managedObjectContext: NSManagedObjectContext?
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Q: This has already been defined in AppDelegate class, why do I need this again?
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch current dataset
        fetchData()
        tableView.reloadData()
    }
    
    func fetchData(){
        let fetch = NSFetchRequest(entityName: "Category")
        //Q: how to "rerange"
//        let prioritySort  = NSSortDescriptor(key: "priority", ascending: false)
        do{
            let fetchResults = try managedObjectContext?.executeFetchRequest(fetch) as! [Category]
            categoryList = fetchResults
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)

        // Configure the cell...
        let category = categoryList[indexPath.row]
        cell.textLabel?.text = category.title
        return cell
    }
    
    @IBAction func unwindToCategoryViewController(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.sourceViewController as? CategoryAddViewController{
            let newCategory = sourceViewController.categoryToAdd
            newCategory!.title = sourceViewController.categoryName.text!
            
            // add category to table view
            let newIndexPath = NSIndexPath(forRow: categoryList.count, inSection: 0)
            categoryList.append(newCategory!)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
            do{
                try managedObjectContext?.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
        }
        // Get selected item if returning from StoreItemTableViewController
//        if let sourceViewController = segue.sourceViewController as? AddAppointmentController {
//            let newAppointment = sourceViewController.appointmentToAdd
//            newAppointment!.title = sourceViewController.titleText.text!
//            newAppointment!.date = sourceViewController.datePicker.date
//            
//            // Add item to table view
//            let newIndexPath = NSIndexPath(forRow: appointments.count, inSection: 0)
//            appointments.append(newAppointment!)
//            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//            
//            do {
//                try managedObjectContext?.save()
//            } catch {
//                fatalError("Failure to save context: \(error)")
//            }
//        }
    }

    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addCategorySegue"
        {
            let addCategoryViewController = segue.destinationViewController as! CategoryAddViewController
//            let navController = segue.destinationViewController as! UINavigationController
//            let addCategoryViewController = navController.viewControllers[0] as! CategoryAddViewController
            addCategoryViewController.managedObjectContext = self.managedObjectContext
        }
        else if segue.identifier == "addCategory"
        {
            let viewCategoryController = segue.destinationViewController as! CategoryAddTableController
            viewCategoryController.managedObjectContext = self.managedObjectContext
        }
    }

}
