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

// Add a category delegate
protocol  AddCategoryDelegate {
    func addCategory(category: Category)
}

//  This viewController adds or edits a category  (file name is different as class name)
class CategoryAddTableController: UITableViewController, SetLocationDelegate, UIPickerViewDelegate, SelectRadiusDelegate, SelectColorDelegate {
    
    var managedObjectContext : NSManagedObjectContext?
    // The delegate when adding a category
    var addCategoryDelegate: AddCategoryDelegate?
    // The delegate when select a radius
    var selectRadiusDelegate: SelectRadiusDelegate?
    // The delegate when select a color
    var selectColorDelegate: SelectColorDelegate?
    // The category which is going to be edited or added
    var category : Category?
    //  A variable identifying the category is going to be added or edited. TRUE: added; FALSE: edited
    var isAddCategory : Bool?
    // The radius which users can choose from
    var radiuses :[String] = ["50m","250m","1000m"]

    // Define different section index in this tableView
    let titleSection = 0
    let locationSection = 1
    let colorSection = 2
    let notifySection = 3
    let radiusSection = 4
    let whenSection = 5
    
    // every section has only one row
    let rowInSection = 0
    
    // Declare different tableViewCell for each section
    // TODO: Some tableViewCells can use one custom cell in this case, can be improved in the future
    var titleCell : TextinputTableViewCell!
    var locationCell : LocationTableViewCell!
    var radiusCell : RadiusTableViewCell!
    var colorCell : CategoryTableViewCell!
    var notifyCell : ToggleTableViewCell!
    var whenCell : SegementTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove blank rows
        tableView.tableFooterView = UIView()
        // Init cells
        initCells()
        // If the category is nil at first begining, 'isAddCategory' is true, else it's false
        if category == nil {
            isAddCategory = true
        }else{
            isAddCategory = false
            // Initialize edit information
            initEditInfo()
        }
        // Add listener to notify switch to control "arriveOrLeave" segment enabled or not
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
        colorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: colorSection)) as! CategoryTableViewCell
        notifyCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: notifySection)) as! ToggleTableViewCell
        radiusCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: radiusSection)) as! RadiusTableViewCell
        whenCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: whenSection)) as! SegementTableViewCell
        // Initialize default category radius which is 1000m
        radiusCell.radiusDisplayField.text = "1000m"
        // Initialize default category color which is red
        colorCell.colorDisplayField.text = CategoryColor.Red.rawValue
        colorCell.colorDisplayField.textColor = CategoryColor.Red.color
    }
    
    // Initialise text fields values for editing if users are going to edit a category
    func initEditInfo(){
        // The edited category
        if let cate = category {
            titleCell.categoryTitleText.text = cate.title
            locationCell.locationDisplayField.text = cate.location
            radiusCell.radiusDisplayField.text = cate.displayRadius()
            colorCell.colorDisplayField.text = cate.color
            colorCell.colorDisplayField.textColor = CategoryColor(rawValue:cate.color!)?.color
            // If category's toogle attribute is 1 which means it needs to be notified, then turn on the swith, otherwise turn it off
            cate.toogle == 1 ? (notifyCell.switchNotify.on = true) : (notifyCell.switchNotify.on = false)
            // If category's notifyByArriveOrLeave is 0 which means it needs to be notified when arrived, otherwise when leaved
            cate.notifyByArriveOrLeave == 0 ? (whenCell.whenSegment.selectedSegmentIndex = 0) : (whenCell.whenSegment.selectedSegmentIndex = 1)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        self.tableView.reloadData()
    }
    
    // Add or edit a category
    @IBAction func addOrEditCategory(sender: AnyObject) {
        // If title is nil, can't save the category
        if titleCell.getText().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            self.showAlertWithDismiss("Invalid input", message: "Category title can not be empty")
            return
        }
        // If location is nil, can't save the category
        if locationCell.locationDisplayField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            self.showAlertWithDismiss("Invalid input", message: "Location can not be empty")
            return
        }
        // If category is nil, which means it's creating a new category, then create a new one in managed object context
        if (category == nil) {
            category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as? Category
        }
        // Pass values from viewController to this category
        category?.title = titleCell.getText()
        category?.location = locationCell.locationDisplayField.text
        category?.radius =  radiusCell.getRadiusNumber()
        category?.color = colorCell.colorDisplayField.text
        // Set category's priority according to its color
        category?.priority = CategoryColor(rawValue: (category?.color)!)?.priority
        notifyCell.switchNotify.on ? (category!.toogle=true) : (category!.toogle=false)
        whenCell.whenSegment.selectedSegmentIndex == 0 ? (category!.notifyByArriveOrLeave = 0) : (category!.notifyByArriveOrLeave = 1)
        // If user is adding a category, then add the category by delegate
        if (isAddCategory == true) {
            self.addCategoryDelegate!.addCategory(category!)
        }else{
            // If user is editing a category, then save it by managedObjectContext
            do{
                try managedObjectContext!.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // When validation for user's input is failed, then pop up an alert to ask user re-enter
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "Re-enter", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Delegates
    
    // Delegate: when a location has been searched
    func setLocation(locationName: String, longitude: Double, latitude: Double) {
        // If category is nil, create a new one in managed object context
        if (category == nil) {
            category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as? Category
        }
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowInSection, inSection: locationSection)) as! LocationTableViewCell
        cell.locationDisplayField.text = locationName
        category?.location = locationName
        category?.latitude = latitude
        category?.longitude = longitude
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 6 sections in this tableViewController
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 row in each section
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Return different cell for differnet section
        switch indexPath.section {
        case titleSection:
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryTitleCell", forIndexPath: indexPath) as! TextinputTableViewCell
            cell.categoryTitleText.placeholder = "Title"
            return cell
        case locationSection:
            return tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! LocationTableViewCell
        case radiusSection:
            return tableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath) as! RadiusTableViewCell
        case colorSection:
            return tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! CategoryTableViewCell
        case notifySection:
            return tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! ToggleTableViewCell
        default:
            return tableView.dequeueReusableCellWithIdentifier("whenCell", forIndexPath: indexPath) as! SegementTableViewCell
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When searching a location, CategoryMapController is going to be displayed
        if segue.identifier == "searchLocationSegue" {
            let mapController = segue.destinationViewController as! CategoryMapController
            // Set setLocationDelegate in CategoryMapController is self
            mapController.setLocationDelegate = self
            // If the category is edited, initialise the category's location in CategoryMapController
            if (isAddCategory == false) {
                let editCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(category!.latitude!), longitude: Double(category!.longitude!))
                mapController.location = editCoordinate
            }
        // When select a radius, RadiusSelectController is going to be displayed
        }else if (segue.identifier == "selectRadiusSegue"){
            let radiusController = segue.destinationViewController as! RadiusSelectController
            // Set selectRadiusDelegate in RadiusSelectController is self
            radiusController.selectRadiusDelegate = self
        // When select a color, ColorSelectController is going to be displayed
        }else if (segue.identifier == "selectColorSegue"){
            let colorController = segue.destinationViewController as! ColorSelectController
            // Set selectColorDelegate in ColorSelectController is self
            colorController.selectColorDelegate = self
        }
    }
}
    
