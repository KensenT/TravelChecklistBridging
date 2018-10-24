//
//  AddNewActivityViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 27/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit
import CoreData

class AddNewActivityViewController: UIViewController{
    
    // MARK: - Properties
    var activity: Activity?
    var activeTextField = UITextField()
    var category: [String] = ["Mountain", "Beach"]
    var delegate: ActivityDataDelegate?
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    var pickerMoved: Bool = false // used if the picker is not moved so set the value to the first in the picker
//    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Outlets
    @IBOutlet weak var activityNameField: UITextField!
    @IBOutlet var locationField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsDelegate()
        createCategoryPicker()
        createDatePicker()
        doneButton.layer.cornerRadius = 5.0
        
        // For background tap gesture
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // Create a delegate for the text field
    func setTextFieldsDelegate() {
        activityNameField.delegate = self
        locationField.delegate = self
    }
    
    // Create Date Picker and Toolbar
    func createDatePicker() {
        
        // Formatting the date picker type
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 30 // adding 30 years from today as the maximum date
        datePicker.maximumDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        
        // Create Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewActivityViewController.dismissDatePicker))
        toolbar.setItems([doneButton], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = datePicker
    }
    
    // Used for Date Picker Done button
    @objc func dismissDatePicker() {
        // Format Date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let date = formatter.string(from: datePicker.date)
        
        dateField.text = String(date)
        view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed() {
        
        // Assigning each value to the activity object
        if (activityNameField.text?.isEmpty==false) && (locationField.text?.isEmpty==false) && (categoryField.text?.isEmpty==false) && (dateField.text?.isEmpty==false){
            let name = activityNameField.text!
            let location = locationField.text!
            let category = categoryField.text!
            let date = dateField.text!
            
            // Finding date difference
            let a = Calendar.current.startOfDay(for: Date())
            let b = Calendar.current.startOfDay(for: datePicker.date)
            let dateDifference = Calendar.current.dateComponents([.day], from: a, to: b)
            let remainingDays = "\(String(describing: dateDifference.day!))"
            
            activity = Activity(name: name, location: location, category: category, date: date, remainingDays: remainingDays)
            
            // Pass data to the previous VC
            delegate?.addActivity(activity: activity!)
            navigationController?.popViewController(animated: true)
            
        } else {
            
            // Alert box if any of the field is empty
            let alert = UIAlertController(title: "", message: "All fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
    

// MARK: - Text Fields Delegation
extension AddNewActivityViewController: UITextFieldDelegate{
    @IBAction func activityFieldPressed() {
        activeTextField = activityNameField
    }
    
    @IBAction func locationFieldPressed() {
        activeTextField = locationField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField.resignFirstResponder()
        return true
    }
}

// MARK: - Category Picker View
extension AddNewActivityViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // Create Category Picker and Toolbar
    func createCategoryPicker() {
        
        // Create Category Picker
        categoryPicker.delegate = self
        
        // Create Toolbar for the Picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        // Done button for the toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewActivityViewController.dismissCategoryPicker))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        categoryField.inputAccessoryView = toolbar
        categoryField.inputView = categoryPicker
    }
    
    // Used for Category Picker Done Button
    @objc func dismissCategoryPicker(){
        if pickerMoved == false {
            categoryField.text = category[0]
        }
        view.endEditing(true)
    }
    
    // Set the number of column in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Set the number of row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    // Set the title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    // Define what to do if a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = category[row]
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
        label.text = category[row]
        return label
    }
}

