//
//  AddViewController.swift
//  Must To Do
//
//  Created by Rian Anjasmara on 10/04/20.
//  Copyright © 2020 Rian Anjasmara. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var labelTodo: UILabel!
    @IBOutlet var titleField: UITextField!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var rTimeField: UITextField!
    
    @IBOutlet var pick: UILabel!

    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    var pickString: String?
    
    public var completion: ((String, String, Date) -> Void)?
    public var pickerData = [String](arrayLiteral: "On Priority","Daily")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        
        
        bottomlineAll()
        createDatePicker()
        createPriorityPicker()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done , target: self, action: #selector(didSave))
    }
    
    func bottomlineAll(){
        labelTodo.text = "Fill the your To-do"
        bottomline()
        bottomline1()
        bottomline2()
    }
    
    
    func bottomline (){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: titleField.frame.height - 2 , width: titleField.frame.width , height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 56/255, green: 87/255, blue: 81/255, alpha: 1).cgColor
        titleField.borderStyle = .none
        titleField.layer.addSublayer(bottomLine)
    }
    func bottomline1 (){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: priorityField.frame.height - 2 , width: priorityField.frame.width , height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 56/255, green: 87/255, blue: 81/255, alpha: 1).cgColor
        priorityField.borderStyle = .none
        priorityField.layer.addSublayer(bottomLine)
    }
    
    func bottomline2 (){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: rTimeField.frame.height - 2 , width: rTimeField.frame.width , height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 56/255, green: 87/255, blue: 81/255, alpha: 1).cgColor
        rTimeField.borderStyle = .none
        rTimeField.layer.addSublayer(bottomLine)
    }
    
    
    func createDatePicker (){
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar Button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress1))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        rTimeField.inputAccessoryView = toolbar
        
        //assign Datepicker
        rTimeField.inputView = datePicker
        
        //date picker Mode
        datePicker.datePickerMode = .dateAndTime
        
    }
    @objc func donePress1(){
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        let time = datePicker.date
        rTimeField.text = formatter.string(from: time)
        self.view.endEditing(true)
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
    
    func createPriorityPicker (){
        //Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        //bar Button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        toolBar.setItems([doneBtn], animated: true)

        //assign Datepicker
        picker.frame(forAlignmentRect: .init(x: 0, y: 0, width: 344, height: 34))
        picker.backgroundColor = .white

        picker.delegate = self
        picker.dataSource = self
        toolBar.isUserInteractionEnabled = true

        priorityField.inputView = picker
        priorityField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func donePress(){
        let test = pickString
        priorityField.text = test
        self.view.endEditing(true)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].self
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = pickerData[row]
        pickString = value
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
}
