//
//  ReminderAddController.swift
//  iosReminder
//
//  Created by zjw on 4/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

// Add reminder delegate
protocol  AddReminderDelegate {
    func addReminder(reminder: Reminder)
}

//  This viewController adds or edits a reminder
class ReminderAddController: UIViewController, UITextViewDelegate {

    @IBOutlet var noteField: UITextView!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var dueDateField: UITextField!
    @IBOutlet var completedSwitch: UISwitch!
    
    var dueDateIntime: NSDate?
    
    var placeholderNote = UILabel()
    // The reminder which is going to be added or edited
    var reminder: Reminder?
    // Identify it is going to add or edit a reminder. TRUE: add ; FALSE: edit
    var isAddReminder: Bool?
    // The catgory that the reminder belongs to
    var currentCategory: Category?
    // Delegate: add a reminder
    var addReminderDelegate: AddReminderDelegate?
    
    var managedObjectContext: NSManagedObjectContext?
    
    // Click on the dueDateField and trigger a datePickerView
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
    
    // Add or edit a reminder to belonged category
    @IBAction func addOrEditReminder(sender: AnyObject) {
        // Reminder title can not be empty
        if titleField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            showAlertWithDismiss("Invalid input", message: "Category title can not be empty")
            return
        }
        if isAddReminder == true {
            reminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: managedObjectContext!) as? Reminder
        }
        reminder?.title = self.titleField.text
        reminder?.note = self.noteField.text
        // If completedSwitch is on, reminder's completed state is completed
        self.completedSwitch.on ? (reminder!.completed=true) : (reminder!.completed=false)
        // If due date changed and not nil, then pass it to reminder's duedate
        if self.dueDateIntime != nil {
            reminder?.dueDate = self.dueDateIntime
        }
        let remindersCollection = currentCategory?.valueForKeyPath("reminders") as! NSMutableSet
        // Bind the currentCategory to this reminder because reminder has a attribute which is cateogry
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
    
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "Re-enter", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteField.delegate = self
        setBorderColors()
        if reminder == nil {
            // add reminder
            isAddReminder = true
        }else{
            // edit reminder
            isAddReminder = false
            initEditInfo(reminder!)
        }
        // Only when noteField is empty, then generate the placeholder for it
        if noteField.text.isEmpty{
            generatePlacehoderForNote()
        }
    }
    
    // Set border and color for noteFiled, dueDateField and titleField
    func setBorderColors(){
        self.titleField.layer.borderWidth = 0.5
        self.titleField.layer.borderColor = UIColor.blackColor().CGColor
        self.noteField.layer.borderWidth = 0.5
        self.noteField.layer.borderColor = UIColor.blackColor().CGColor
        self.dueDateField.layer.borderWidth = 0.5
        self.dueDateField.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    // Initialise reminder's information
    func initEditInfo(reminder: Reminder){
        titleField.text = reminder.title
        if reminder.dueDate != nil {
            dueDateField.text = getDueDateText(reminder.dueDate!)
        }
        noteField.text = reminder.note
        (reminder.completed==true) ? (completedSwitch.on = true) : (completedSwitch.on = false)
    }
    
    // When the note textView content is not empty, hide placeHolder
    func textViewDidChange(textView: UITextView) {
        if noteField.text.isEmpty {
            placeholderNote.hidden = false
        }else{
            placeholderNote.hidden = true
        }
    }
    
    // Generate a placehoder for note textView
    func generatePlacehoderForNote(){
        // create placeholder programmatically
        // reference: www.youtube.com/watch?v=ixJhbYvJUTE
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
    
    // Get due time in a format text
    func getDueDateText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
