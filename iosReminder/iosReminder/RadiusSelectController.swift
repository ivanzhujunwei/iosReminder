//
//  RadiusSelectController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// Delegate: select a radius
protocol SelectRadiusDelegate {
    func selectRadius(radius: String)
}

// This viewController provides 3 radius for choosing
class RadiusSelectController: UITableViewController {

    var selectRadiusDelegate: SelectRadiusDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("radiusSelectCell", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "50m"
            break
        case 1:
            cell.textLabel?.text = "250m"
            break
        default:
            cell.textLabel?.text = "1000m"
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get selected row index
        let indexPath = tableView.indexPathForSelectedRow!
        // Get selected cell
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        // Use delegate to set radius to reminder detail viewController
        selectRadiusDelegate?.selectRadius(currentCell.textLabel!.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }

}
