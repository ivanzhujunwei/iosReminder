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

class CategoryAddTableController: UITableViewController, SetLocationDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var managedObjectContext : NSManagedObjectContext?
    var categoryToAdd : Category?
    var addCategoryDelegate: AddCategoryDelegate?
    
    @IBOutlet var colorPickerView: UIPickerView!
    
    var colors:[CategoryColor]?
    var picker = UIPickerView()

    let titleSection = 0
    let locationSection = 1
    let radiusSection = 2
    let colorSection = 3
    let notifySection = 4
    let whenSection = 5
    let rowInSection = 0 // every section has only one row
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        colors = [CategoryColor.Blue,CategoryColor.Red]
        
        // reference: www.youtube.com/watch?v=DgHEL1bWQ58
//        colorPickerView.dataSource = self
//        colorPickerView.delegate = self
//        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: colorSection)) as! CategoryTableViewCell
//        text.inputView = picker
        
        // the added category
        categoryToAdd = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as? Category
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    ///// for picker views
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return colors!.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: colorSection)) as! CategoryTableViewCell
        cell.colorDisplayField.text = colors![row].rawValue
    }

    ///// end for picker views

    @IBAction func addCategory(sender: AnyObject) {
        let sections = numberOfSectionsInTableView(self.tableView)
        for section in 0 ..< sections {
           
            switch section {
            case 0:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: section)) as! TextinputTableViewCell
                categoryToAdd?.title = cell.getText()
                break
            case 1:
//                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: section)) as! CategoryTableViewCell
//                categoryToAdd?.location = cell.textDisplayField.text
                break
            case 2:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: section)) as! CategoryTableViewCell
                categoryToAdd?.radius = Double(cell.radiusDisplayField.text!)
                break
            case 3:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: section)) as! CategoryTableViewCell
                categoryToAdd?.color = cell.colorDisplayField.text
                break
            case 4:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: section)) as! ToggleTableViewCell
                if(cell.switchNotify.on){
                    categoryToAdd?.toogle=true
                }else{
                    categoryToAdd?.toogle=false
                }
                break
            default:
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: section)) as! SegementTableViewCell
                
                if(cell.whenSegment.selectedSegmentIndex == 0){// arrive
                    categoryToAdd?.notifyByArriveOrLeave = 0
                }else{// leave
                    categoryToAdd?.notifyByArriveOrLeave = 1
                }
                break
            }
        }
        self.addCategoryDelegate!.addCategory(categoryToAdd!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setLocation(locationName: String, longitude: Double, latitude: Double) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: locationSection)) as! CategoryTableViewCell
        cell.textDisplayField.text = locationName
        categoryToAdd?.location = locationName
        categoryToAdd?.latitude = latitude
        categoryToAdd?.longitude = longitude
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
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryTitleCell", forIndexPath: indexPath) as! TextinputTableViewCell
            cell.categoryTitleText.text = ""
            cell.categoryTitleText.placeholder = "Title"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! CategoryTableViewCell
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath) as! CategoryTableViewCell
            cell.radiusDisplayField.text = "50"
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! CategoryTableViewCell
            cell.colorDisplayField.text = "red"
            return cell
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! ToggleTableViewCell
            cell.switchNotify.on = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("whenCell", forIndexPath: indexPath) as! SegementTableViewCell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "searchLocationSegue" {
//            let viewCategoryController = segue.destinationViewController as! CategoryAddTableController
//            viewCategoryController.managedObjectContext = self.managedObjectContext
//            viewCategoryController.addCategoryDelegate = self
            let mapController = segue.destinationViewController as! CategoryMapController
            mapController.setLocationDelegate = self
        }
    }

}
