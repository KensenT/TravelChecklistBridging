//
//  ViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 26/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit
import CloudKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 57/255, green: 172/255, blue: 217/255, alpha: 1)
        self.fetchFromCK()
    }
    
    func sortActivities(){
        self.activities.sort {$0.date < $1.date}
    }
    
    func recordToActivity(record: CKRecord) -> Activity{
        let name: String = record["name"]!
        let location: String = record["location"]!
        let category: String = record["category"]!
        let date: String = record["date"]!
        let remainingDays: String = record["remainingDays"]!
        let image1: String = record["image1"]!
        let image2: String = record["image2"]!
        let tempRemainingTask: [String] = record["remainingTask"]!
        
        var remainingTask: [Task] = []
        for singleTask in tempRemainingTask{
            let data: Data = singleTask.data(using: .utf8)!
            
            do{
                let dict: [String:Any] = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let taskName: String = dict["name"] as! String
                let taskPic: String = dict["pic"] as! String
                let taskDescriptions: String = dict["descriptions"] as! String
                let taskCompleted: Bool = dict["completed"] as! Bool
                
                let newTask = Task(name: taskName, pic: taskPic, description: taskDescriptions, completed: taskCompleted)
                remainingTask.append(newTask)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let newActivity = Activity(name: name, location: location, category: category, date: date, remainingDays: remainingDays)
        newActivity.remainingTask.append(contentsOf: remainingTask)
        newActivity.image1 = image1
        newActivity.image2 = image2
        return newActivity
    }
    
    func fetchFromCK(){
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Activity", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let err = error{
                print("Error: \(err.localizedDescription)")
            }
            if let fetchedRecords = records{
                for singleRecord in fetchedRecords{
                    let activity = self.recordToActivity(record: singleRecord)
                    self.activities.append(activity)
                }
            }
            DispatchQueue.main.async {
                self.sortActivities()
                self.tableView.reloadData()
            }
        }
    }
    
    func saveActivityToCK(addedActivity: Activity){
        let activityRecord = CKRecord(recordType: "Activity")
        
        activityRecord["name"] = addedActivity.name
        activityRecord["location"] = addedActivity.location
        activityRecord["category"] = addedActivity.category
        activityRecord["date"] = addedActivity.date
        activityRecord["remainingDays"] = addedActivity.remainingDays
        activityRecord["image1"] = addedActivity.image1
        activityRecord["image2"] = addedActivity.image2
        
        var tempTasks: [String] = []
        for singleTask in addedActivity.remainingTask{
            var newTaskDict: [String:Any] = [:]
            
            newTaskDict["name"] = String(singleTask.name)
            newTaskDict["pic"] = String(singleTask.pic)
            newTaskDict["descriptions"] = String(singleTask.descriptions)
            newTaskDict["completed"] = Bool(singleTask.completed)
            
            do{
                let tempData = try JSONSerialization.data(withJSONObject: newTaskDict, options: .prettyPrinted)
                let dataString: String = String(bytes: tempData, encoding: .utf8)!
                tempTasks.append(dataString)
            } catch {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
        
        activityRecord["remainingTask"] = tempTasks
        
        // ---------------------------------------------------------------
        // Save to CK public database
        
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
        database.save(activityRecord) { (savedRecord, error) in
            if let err = error{
                print(err.localizedDescription)
            }
            if let _ = savedRecord{
                //                print(r)
            }
        }
        
        // ---------------------------------------------------------------
    }
    
    func createArray() -> [Activity]{
        
        var tempActivities: [Activity] = []
        
        let activity1 = Activity(name: "Birthday Trip", location: "Kuta Beach", category: "Beach", date: "June 11, 2018", remainingDays: "35")
        let activity2 = Activity(name: "Team's Outing", location: "Mt. Semeru", category: "Mountain", date: "July 14, 2018", remainingDays: "68")

        tempActivities.append(activity1)
        tempActivities.append(activity2)
        
        return tempActivities
    }
}


// CHECK CONNECTION STATUS

extension HomeViewController{
    
    
    
    
    
    
    
    
}









extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        
        cell.layer.borderWidth = 10.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 20
        
        cell.setActivity(activity: activity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "homeToDetail", sender: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController{
            destination.activity = activities[index]
            destination.activityIndex = index
            destination.delegate = self
            
        } else if let destination = segue.destination as? AddNewActivityViewController{
            destination.delegate = self
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}

extension HomeViewController: ActivityDataDelegate {
    func editActivity(activity: Activity, index: Int) {
        activities[index] = activity
        tableView.reloadData()
    }
    
    func addActivity(activity: Activity) {
        activities.append(activity)
        self.sortActivities()
        self.saveActivityToCK(addedActivity: activity)
        tableView.reloadData()
    }
    
    func deleteActivity(activity: Activity, index: Int) {
        activities.remove(at: index)
        tableView.reloadData()
    }
}
