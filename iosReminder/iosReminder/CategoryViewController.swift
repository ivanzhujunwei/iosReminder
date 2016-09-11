//
//  CategoryViewController.swift
//  iosReminder
//
//  Created by zjw on 30/08/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

//  This viewController displays the category list to show users all the catgoryies
class CategoryViewController: UITableViewController, AddCategoryDelegate {

    // CategoryList stored in Core Data
    var categoryList : [Category]!
    var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch current data again so that data is sorted
        fetchData()
        self.tableView.reloadData()
        // Initialise mapAnnotationView's annotation and the monitored regions
        iniMapAnnotationView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: Implement AddCategoryDelegate method
    // Add a category into categoryList and save it
    func addCategory(category: Category) {
        categoryList.append(category)
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    
    // MARK: - Table view data source

    // Fetch current dataset
    func fetchData(){
        // Declare fetch entityName
        let fetch = NSFetchRequest(entityName: "Category")
        // Declare the sort approach, sort by priority in ascending order
        let prioritySort  = NSSortDescriptor(key: "priority", ascending: true)
        fetch.sortDescriptors = [prioritySort]
        do{
            // Fetch request
            let fetchResults = try managedObjectContext.executeFetchRequest(fetch) as! [Category]
            // Initialise the categoryList using fetch results
            categoryList = fetchResults
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // One section in this tableView
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The number of rows is the length of catgoryList in this tableView section
        return categoryList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
        // Configure the cell
        let category = categoryList[indexPath.row]
        // Define cell's text which is category's title
        cell.textLabel?.text = category.title
        // Define cell's detailText which is category's location
        cell.detailTextLabel?.text = category.location
        // Define cell's color which is category's color
        cell.textLabel?.textColor = CategoryColor(rawValue: category.color!)?.color
        return cell
    }
    
    // Initilatise values for CategoryMapAnnotationController
    func iniMapAnnotationView(){
        let mapAnotationController = self.tabBarController?.viewControllers![1].childViewControllers[0] as! CategoryMapAnnotationController
        mapAnotationController.categoryList = self.categoryList
        mapAnotationController.managedObjectContext = self.managedObjectContext
        // Update monitored regions
        mapAnotationController.updateMonitoredRegions()
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // When delete a row
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(categoryList[indexPath.row])
            // Delete the row from categoryList
            categoryList.removeAtIndex(indexPath.row)
            // Delete the row in the tableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            do{
                // Save the managedObjectContext
                try self.managedObjectContext.save()
                // Update monitored regions in CategoryMapAnnotationController
                iniMapAnnotationView()
            }catch let error {
                print("Could not save Deletion \(error)")
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When viewing a category, ReminderListController is going to be displayed
        if segue.identifier == "viewCategorySeg"
        {
            let viewController = segue.destinationViewController as! ReminderListController
            // Get selected row index
            let indexPath = tableView.indexPathForSelectedRow
            // Pass the selected category to ReminderListController
            viewController.categoryToView = categoryList[indexPath!.row]
            // Pass managedObjectContext to ReminderListController
            viewController.managedObjectContext = self.managedObjectContext
        }
        // When adding a category, CategoryAddTableController is going to be displayed
        else if segue.identifier == "addCategorySegue"
        {
            let viewCategoryController = segue.destinationViewController as! CategoryAddTableController
            // Pass managedObjectContext to CategoryAddTableController
            viewCategoryController.managedObjectContext = self.managedObjectContext
            // Set CategoryAddTableController's addCategoryDelegate is self
            viewCategoryController.addCategoryDelegate = self
        }
    }

}
