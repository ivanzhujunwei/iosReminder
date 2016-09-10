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

// Category add and edit controller (file name is different as class name)
class CategoryAddTableController: UITableViewController, SetLocationDelegate, UIPickerViewDelegate, SelectRadiusDelegate, SelectColorDelegate {
    
    var managedObjectContext : NSManagedObjectContext?
    var addCategoryDelegate: AddCategoryDelegate?
    var selectRadiusDelegate: SelectRadiusDelegate?
    var selectColorDelegate: SelectColorDelegate?
    // the category which is going to be edited or added
    var category : Category?
    var isAddCategory : Bool?
    
    var radiuses :[String] = ["50m","250m","1000m"]
    //  var colors:[CategoryColor]?
    // section index
    let titleSection = 0
    let locationSection = 1
    let radiusSection = 2
    let colorSection = 3
    let notifySection = 4
    let whenSection = 5
    
    // every section has only one row
    let rowInSection = 0
    
    var titleCell : TextinputTableViewCell!
    var locationCell : LocationTableViewCell!
    var radiusCell : RadiusTableViewCell!
    var colorCell : CategoryTableViewCell!
    var notifyCell : ToggleTableViewCell!
    var whenCell : SegementTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove blank rows
        tableView.tableFooterView = UIView()
        initCells()
        // the added category
        if category == nil {
            isAddCategory = true
        }else{
            isAddCategory = false
            // initialise edit information
            initEditInfo()
        }
        // add listener to notify switch to control "arriveOrLeave" segment enabled or not
        notifyCell.switchNotify.addTarget(self, action: #selector(CategoryAddTableController.switchChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    // Once the switch turn off, disable segment
    func switchChanged(toggle: UISwitch) {
        if toggle.on {
            whenCell.whenSegment.enabled = true
        }else{
            whenCell.whenSegment.enabled = false
        }
    }

    // Initialise the cells in different section of this tableView
    func initCells(){
        titleCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: titleSection)) as! TextinputTableViewCell
        locationCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: locationSection)) as! LocationTableViewCell
        radiusCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: radiusSection)) as! RadiusTableViewCell
        notifyCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: notifySection)) as! ToggleTableViewCell
        colorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: colorSection)) as! CategoryTableViewCell
        whenCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: whenSection)) as! SegementTableViewCell
        // initialize default category radius
        radiusCell.radiusDisplayField.text = "1000m"
        // initialize default category color
        colorCell.colorDisplayField.text = CategoryColor.Red.rawValue
        colorCell.colorDisplayField.textColor = CategoryColor.Red.color
    }
    
    // If we have been passed an item for editing, we need to modify text fields to show current values
    func initEditInfo(){
        // the edited category
        if let cate = category {
            titleCell.categoryTitleText.text = cate.title
            locationCell.locationDisplayField.text = cate.location
            radiusCell.radiusDisplayField.text = cate.displayRadius()
            colorCell.colorDisplayField.text = cate.color
            colorCell.colorDisplayField.textColor = CategoryColor(rawValue:cate.color!)?.color
            cate.toogle == 1 ? (notifyCell.switchNotify.on = true) : (notifyCell.switchNotify.on = false)
            cate.notifyByArriveOrLeave == 0 ? (whenCell.whenSegment.selectedSegmentIndex = 0) : (whenCell.whenSegment.selectedSegmentIndex = 1)
        }
    }
    
    // Delegate function: select a radius for the category.
    func selectRadius(radius: String) {
        radiusCell.radiusDisplayField.text = radius
    }
    
    // Delegate function: select a color for the category.
    func selectColor(color: CategoryColor) {
        colorCell.colorDisplayField.textColor = color.color
        colorCell.colorDisplayField.text = color.rawValue
    }
    
    // Ask for the number of columns in your picker element.
    // For example, if you wanted to do a picker for selecting time, you might have 3 components; one for each of hour, minutes and seconds
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radiuses.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    // Asks for the data for a specific row and specific component
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return radiuses[row]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func addOrEditCategory(sender: AnyObject) {
        if (isAddCategory == true) {
            category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as? Category
        }
        category?.title = titleCell.getText()
        category?.location = locationCell.locationDisplayField.text
        category?.radius =  radiusCell.getRadiusNumber()
        category?.color = colorCell.colorDisplayField.text
        category?.priority = CategoryColor(rawValue: (category?.color)!)?.priority
        notifyCell.switchNotify.on ? (category!.toogle=true) : (category!.toogle=false)
        whenCell.whenSegment.selectedSegmentIndex == 0 ? (category!.notifyByArriveOrLeave = 0) : (category!.notifyByArriveOrLeave = 1)
        if (isAddCategory == true) {
            self.addCategoryDelegate!.addCategory(category!)
        }else{
            do{
                try managedObjectContext!.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setLocation(locationName: String, longitude: Double, latitude: Double) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: locationSection)) as! LocationTableViewCell
        cell.locationDisplayField.text = locationName
        category?.location = locationName
        category?.latitude = latitude
        category?.longitude = longitude
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryTitleCell", forIndexPath: indexPath) as! TextinputTableViewCell
            cell.categoryTitleText.placeholder = "Title"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! LocationTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath) as! RadiusTableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! CategoryTableViewCell
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! ToggleTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("whenCell", forIndexPath: indexPath) as! SegementTableViewCell
            return cell;
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // reference: www.youtube.com/watch?v=VWgr_wNtGPM
        //        let previousIndexpath = selectedIndexPath
        //        // if the indexpath is clicked, it should be cllopased
        //        if indexPath ==  selectedIndexPath {
        //            selectedIndexPath = nil
        //        }else{
        //            selectedIndexPath = indexPath
        //        }
        //        // figure out which indexPath should be reload
        //        var indexPaths : Array<NSIndexPath> = []
        //        if let previous =  previousIndexpath{
        //            indexPaths += [previous]
        //        }
        //        if let current = selectedIndexPath {
        //            indexPaths += [current]
        //        }
        //        if indexPaths.count > 0{
        //            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        //        }
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
     }*/
    
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
            if (isAddCategory == false) {
                let editCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(category!.latitude!), longitude: Double(category!.longitude!))
                mapController.location = editCoordinate
            }
        }else if (segue.identifier == "selectRadiusSegue"){
            let radiusController = segue.destinationViewController as! RadiusSelectController
            radiusController.selectRadiusDelegate = self
        }else if (segue.identifier == "selectColorSegue"){
            let colorController = segue.destinationViewController as! ColorSelectController
            colorController.selectColorDelegate = self
        }
    }
    
}
