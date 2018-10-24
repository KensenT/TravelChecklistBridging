//
//  AddNewTaskViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 01/05/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class AddNewTaskViewController: UIViewController {
    
    // MARK: - Properties
    var task = Task()
    var delegate : TaskDataDelegate?
    var pic: [String] = [User().username] + User().friends
    var pickerMoved: Bool = false // used if the picker is not moved so set the value to the first in the picker
    
    
    // MARK: - Outlets
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var picField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsDelegate()
        createPicPicker()
        doneButton.layer.cornerRadius = 5.0
        descriptionField.layer.cornerRadius = 5.0
        
        // For background tap gesture
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // MARK: - Done Button
    @IBAction func doneButtonPressed() {
        if (taskNameField.text?.isEmpty==false) && (picField.text?.isEmpty==false) {
            task.name = taskNameField.text!
            task.pic = picField.text!
            task.completed = false
            task.descriptions = descriptionField.text
            delegate?.addTask(task: task)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Set the delegates for text field
    func setTextFieldsDelegate() {
        taskNameField.delegate = self
    }
}


// MARK: - Text Fields
extension AddNewTaskViewController: UITextFieldDelegate {
    // This process will remove the keyboard when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameField.resignFirstResponder()
        return true
    }
}


// MARK: - PIC Picker
extension AddNewTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // Create the PIC picker and Toolbar
    func createPicPicker() {
        let picPicker = UIPickerView()
        picPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewTaskViewController.dismissPicPicker))
        
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
