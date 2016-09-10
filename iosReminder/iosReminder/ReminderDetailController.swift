//
//  ReminderAddController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

protocol  AddReminderDelegate {
    func addReminder(reminder: Reminder)
}

class ReminderAddController: UIViewController, UITextViewDelegate {

    @IBOutlet var noteField: UITextView!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var dueDateField: UITextField!
    @IBOutlet var completedSwitch: UISwitch!
    
    var dueDateIntime: NSDate?
    
    var placeholderNote = UILabel()
    
    var reminder: Reminder?
    var isAddReminder: Bool?
    var currentCategory: Category?
    
    var managedObjectContext: NSManagedObjectContext?
    var addReminderDelegate: AddReminderDelegate?
    
    // click on the dueDateField
    @IBAction func dueDateEdit(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ReminderAddController.datePickerValueChanged), forControlEvents: .ValueChanged)
    }
    
    func datePickerValueChanged(sender: UIDatePicker){
        dueDateField.text = getDueDateText(sender.date)
        // initialise reminder's dueDate
        dueDateIntime = sender.date
    }
    
    // add a reminder to a category
    @IBAction func addOrEditReminder(sender: AnyObject) {
        if isAddReminder == true {
            reminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: managedObjectContext!) as? Reminder
        }
        reminder?.title = self.titleField.text
        reminder?.note = self.noteField.text
        // if completedSwitch is on, reminder's completed state is completed
        self.completedSwitch.on ? (reminder!.completed=true) : (reminder!.completed=false)
        // if due date changed
        if self.dueDateIntime != nil {
            reminder?.dueDate = self.dueDateIntime
        }
        let remindersCollection = currentCategory?.valueForKeyPath("reminders") as! NSMutableSet
        // bind the currentCategory to this reminder because reminder has a attribute which is cateogry
        reminder?.category = currentCategory
        remindersCollection.addObject(reminder!)
        currentCategory?.reminders? = remindersCollection
        if isAddReminder == true {
            addReminderDelegate?.addReminder(reminder!)
        }else{
            do{
                try self.managedObjectContext?.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteField.delegate = self
        setBorderColors()
        generatePlacehoderForNote()
        if reminder == nil {
            // add reminder
            isAddReminder = true
        }else{
            // edit reminder
            isAddReminder = false
            initEditInfo(reminder!)
        }
    }
    
    // set border and color for noteFiled, dueDateField and titleField
    func setBorderColors(){
        self.titleField.layer.borderWidth = 0.5
        self.titleField.layer.borderColor = UIColor.blackColor().CGColor
        self.noteField.layer.borderWidth = 0.5
        self.noteField.layer.borderColor = UIColor.blackColor().CGColor
        self.dueDateField.layer.borderWidth = 0.5
        self.dueDateField.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func initEditInfo(reminder: Reminder){
        titleField.text = reminder.title
        dueDateField.text = getDueDateText(reminder.dueDate!)
        noteField.text = reminder.note
        (reminder.completed==true) ? (completedSwitch.on = true) : (completedSwitch.on = false)
    }
    
    // when the text field content changes
    func textViewDidChange(textView: UITextView) {
        if noteField.text.isEmpty {
            placeholderNote.hidden = false
        }else{
            placeholderNote.hidden = true
        }
    }
    
    // generate a placehoder for note textView
    func generatePlacehoderForNote(){
        // reference: www.youtube.com/watch?v=ixJhbYvJUTE
        // create placeholder programmatically
        // use "self.view.size" computing for different screen size
        let placeholderX : CGFloat = self.view.frame.size.width / 75
        let placeholderY : CGFloat = 0
        let placehoderWidth = noteField.bounds.width - placeholderX
        let placehoderHeight = noteField.bounds.height
        let placeFontSize = self.view.frame.size.width / 25
        placeholderNote.font = UIFont(name:"HelveticaNeue", size:placeFontSize)
        placeholderNote.frame = CGRectMake(placeholderX, placeholderY, placehoderWidth, placehoderHeight)
        placeholderNote.text = "Enter notes..."
        placeholderNote.textColor = UIColor.lightGrayColor()
        placeholderNote.textAlignment = NSTextAlignment.Left
        noteField.addSubview(placeholderNote)
    }
    
    // get due time in a format text
    func getDueDateText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
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
