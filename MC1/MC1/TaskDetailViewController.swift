//
//  TaskDetailViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 30/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    var task = Task()
    var index: Int = 0
    var finalCompletionStatus: Bool?
    var delegate: TaskDataDelegate?
    var pic: [String] = [User().username] + User().friends
    var pickerMoved: Bool = false // used if the picker is not moved so set the value to the first in the picker
    
    // MARK: - Outlets
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var picField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameField.text = task.name
        picField.text = task.pic
        descriptionField.text = task.descriptions
        
        if task.completed == false {
            statusSegment.selectedSegmentIndex = 0
        } else {
            statusSegment.selectedSegmentIndex = 1
        }
        
        setTextFieldsDelegate()
        createPicPicker()
        descriptionField.layer.cornerRadius = 5.0
        doneButton.layer.cornerRadius = 5.0
        
        // For background tap gesture
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // Set the delegates for text field
    func setTextFieldsDelegate() {
        taskNameField.delegate = self
        picField.delegate = self
    }
    
    // Action for the segment
    @IBAction func statusSegmentSelected() {
        if task.completed == true {
            finalCompletionStatus = false
        } else {
            finalCompletionStatus = true
        }
    }
    
    // MARK: - Done Button
    @IBAction func doneButtonPressed() {
        if (taskNameField.text?.isEmpty==false) && (picField.text?.isEmpty==false) {
            
            if finalCompletionStatus != nil {
                task.completed = finalCompletionStatus!
            }
            
            task.name = taskNameField.text!
            task.pic = picField.text!
            task.descriptions = descriptionField.text
            delegate?.editTask(task: task, index: index, completed: finalCompletionStatus)
            navigationController?.popViewController(animated: true)
        } else {
            
            // Provide an alert box if any of the field is empty
            let alert = UIAlertController(title: "", message: "All fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Delete Button
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        // Prompting with alert box
        let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            self.delegate?.deleteTask(task: self.task, index: self.index)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Text Fields
extension TaskDetailViewController: UITextFieldDelegate {
    // This process will remove the keyboard when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameField.resignFirstResponder()
        return true
    }
}


// MARK: - PIC Picker
extension TaskDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // Create the PIC picker and Toolbar
    func createPicPicker() {
        let picPicker = UIPickerView()
        picPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(TaskDetailViewController.dismissPicPicker))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        picField.inputAccessoryView = toolbar
        picField.inputView = picPicker
    }
    
    // Used for PIC Picker Done Button
    @objc func dismissPicPicker(){
        if pickerMoved == false{
            picField.text = User().username
        }
        view.endEditing(true)
    }
    
    // Set the number of column in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Set the number of row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pic.count
    }
    
    // Set the title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pic[row]
    }
    
    // Define what to do if a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picField.text = pic[row]
        pickerMoved = true
    }
    
    // Set the style for each row
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        
        if let view = view as? UILabel{
            label = view
        }
        
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "Malayaalam Sangam MN", size: 35)
        label.text = pic[row]
        return label
    }
}
