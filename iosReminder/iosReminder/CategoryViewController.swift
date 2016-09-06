//
//  CategoryViewController.swift
//  iosReminder
//
//  Created by zjw on 30/08/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController, AddCategoryDelegate {

    var categoryList : [Category]!
    var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Q: This has already been defined in AppDelegate class, why do I need this again?
        self.managedObjectContext = appDelegate.managedObjectContext
//        self.categoryList = appDelegate.categoryList
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch current dataset
        fetchData()
        // reference: stackoverflow.com/questions/28708574/how-to-remove-extra-empty-cells-in-tableviewcontroller-ios-swift
        // delete blank rows
        tableView.tableFooterView = UIView()
    }
    
    func fetchData(){
        let fetch = NSFetchRequest(entityName: "Category")
        //Q: how to "rerange"
//        let prioritySort  = NSSortDescriptor(key: "priority", ascending: false)
        do{
            let fetchResults = try managedObjectContext.executeFetchRequest(fetch) as! [Category]
            categoryList = fetchResults
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
    }
    
    func addCategory(category: Category) {
        let newIndexPath = NSIndexPath(forRow: categoryList.count, inSection: 0)
        categoryList.append(category)
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section)
        {
        case 0: return categoryList.count
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
        // Configure the cell...
        let category = categoryList[indexPath.row]
        cell.textLabel?.text = category.title
        cell.detailTextLabel?.text = category.location
        return cell
    }
    
//    @IBAction func unwindToCategoryViewController(segue: UIStoryboardSegue) {
//        print(111)
//        if let sourceViewController = segue.sourceViewController as? CategoryAddTableController{
//            let newCategory = sourceViewController.categoryToAdd
//////            sourceViewController.
////            newCategory!.title = sourceViewController.categoryToAdd
//            // add category to table view
//            let title = sourceViewController.categoryToAdd?.title
//            newCategory?.title = title
//            let newIndexPath = NSIndexPath(forRow: categoryList.count, inSection: 0)
//            categoryList.append(newCategory!)
//            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//            do{
//                try managedObjectContext?.save()
//            }catch{
//                fatalError("Failure to save context: \(error)")
//            }
//        }
//    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(categoryList[indexPath.row])
            categoryList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // save the managedObjectContext
            do{
               try self.managedObjectContext.save()
            }catch let error {
                print("Could not save Deletion \(error)")
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewCategorySeg"
        {
            let viewController = segue.destinationViewController as! ReminderListController
            let indexPath = tableView.indexPathForSelectedRow
            viewController.categoryToView = categoryList[indexPath!.row]
            viewController.managedObjectContext = self.managedObjectContext
        }
        else if segue.identifier == "addCategorySegue"
        {
            let viewCategoryController = segue.destinationViewController as! CategoryAddTableController
            viewCategoryController.managedObjectContext = self.managedObjectContext
            viewCategoryController.addCategoryDelegate = self
        }
    }

}
