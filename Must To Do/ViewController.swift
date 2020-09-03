//
//  ViewController.swift
//  Must To Do
//
//  Created by Rian Anjasmara on 10/04/20.
//  Copyright © 2020 Rian Anjasmara. All rights reserved.
//


import UserNotifications
import UIKit
import CoreData

struct MyReminder {
    let title: String
    let date: Date
    let body: String
    let identifier: String
}

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var DataItems = [DataItem]()
    var models = [MyReminder]()
    var pickString: String?
    
    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        
        UNUserNotificationCenter.current().delegate = self
        loadData()
        
        //navigationItem.leftBarButtonItem = editButtonItem
        
        
    }
    
   
    
    @IBAction func tapAdd(){
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        vc.title = " New Task "
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body , date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, body: body, identifier: "id_\(title)")
                
                let newData = DataItem(context: self.context)
                
                newData.titleCore = title
                newData.dateCore = date
                newData.priorityCore = body
                self.DataItems.append(newData)
                //self.saveData()
                self.models.append(new)
                // self.table.reloadData()
                self.saveData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = "Time to do next Task. Are you have done?"
                
                let targetDate = date
                print(targetDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil{
                        print("Something went wrong")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert])
        center.removeAllPendingNotificationRequests()
    }
}
extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataItems.count == 0 {
        tableView.setEmptyView(title: "You don't have any To-Do", message: "Your Must To-Do will be in here.")
        }
        else {
        tableView.restore()
        }
        
        
        return DataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! makeTableViewCell
        let item = DataItems[indexPath.row]
        cell.titleTextLabel?.text = item.titleCore
        
        let date = item.dateCore
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        cell.dateTextLabel?.text = formatter.string(from: date!)
        
        cell.priorityLabel?.text = item.priorityCore
        if (item.priorityCore != "Daily") {
            cell.priorityLabel?.textColor = .red
            cell.blokView.backgroundColor = .systemRed
        } else {
            cell.priorityLabel?.textColor = .blue
            cell.blokView.backgroundColor = .systemBlue
        }
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    //Delete Slider
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            context.delete(DataItems[indexPath.row])
            DataItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
            tableView.endUpdates()
        }
    }
    
    
    // func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //    let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
    //        //Delete To-do
    //        completion(true)
    //        }
    //        action.backgroundColor = .green
    //        return UISwipeActionsConfiguration(actions: [action])
    //    }
    //
    func saveData(){
        do{
            try context.save()
        } catch {
            print("error saving with Error \(error)")
        }
        table.reloadData()
    }
    
    func loadData(){
        let request : NSFetchRequest<DataItem> = DataItem.fetchRequest()
        do{
            DataItems = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")
        }
        table.reloadData()
    }
    
}

class makeTableViewCell: UITableViewCell {
    @IBOutlet var titleTextLabel: UILabel!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var blokView: UIView!
    
}






