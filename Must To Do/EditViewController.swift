//
//  AddViewController.swift
//  Must To Do
//
//  Created by Rian Anjasmara on 10/04/20.
//  Copyright © 2020 Rian Anjasmara. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var labelTodo: UILabel!
    @IBOutlet weak var labelReminder: UILabel!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var pick: UILabel!
    @IBOutlet var picker: UIPickerView!
    var pickString: String?

    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    public var pickerData = [String](arrayLiteral: "On Priority","Daily")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done , target: self, action: #selector(didSave))
    }

    @objc func didSave() {
        if let titleText = titleField.text, !titleText.isEmpty,  let body = pickString
        {
            let targetDate = datePicker.date
            
         completion?(titleText, body , targetDate)
        }
        func textFieldShouldReturn( textField: UITextField) ->Bool{
            textField.resignFirstResponder()
            return true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].self
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = pickerData[row]
        pick.text = pickerData[row]
        pickString = value
     
        
    
    }
}
