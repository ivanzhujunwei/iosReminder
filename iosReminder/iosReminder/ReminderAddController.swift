//
//  ReminderAddController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class ReminderAddController: UIViewController {

    var managedObjectContext: NSManagedObjectContext?
    var reminderToAdd: Reminder?
    var currentCategory: Category?
    
    @IBAction func addReminder(sender: AnyObject) {
        reminderToAdd = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: managedObjectContext!) as? Reminder
        reminderToAdd?.title = self.titleField.text
        reminderToAdd?.note = self.noteField.text
        reminderToAdd?.dueDate = self.duePicker.date
        let remindersCollection = currentCategory?.valueForKeyPath("reminders") as! NSMutableSet
        remindersCollection.addObject(reminderToAdd!)
        currentCategory?.reminders? = remindersCollection
        do{
            try managedObjectContext?.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var duePicker: UIDatePicker!
    @IBOutlet var noteField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteField.layer.borderColor = UIColor.blackColor().CGColor
        self.noteField.layer.borderWidth = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
