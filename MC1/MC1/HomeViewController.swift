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
    @IBOutlet weak var collectionView: UICollectionView!
    var index = 0
    var activities: [Activity] = []
    
    var isOffline: Bool = false
    var checkTimer: Timer!
    
    var fetchedFromCK: Bool = false
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 57/255, green: 172/255, blue: 217/255, alpha: 1)
        self.initialConnectionCheck()
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
        if (self.fetchedFromCK == false)
        {
            self.fetchedFromCK = true
        }
        else
        {
            return
        }
        print("Refreshing data")
        self.activities.removeAll()
        
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
                self.collectionView.reloadData()
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
    
    
    func setStatusBar(status: Bool)
    {
        if (status)
        {
            self.statusBarView.backgroundColor = UIColor.green
            self.statusLabel.text = "You are connected"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.statusBarView.frame.origin.y = self.statusBarView.frame.origin.y - 42
                }) { (finished) in
                    self.statusBarView.isHidden = true
                }
            }
        }
        else
        {
            self.statusBarView.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
            self.statusLabel.text = "No Internet Connection"
            self.statusBarView.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.statusBarView.frame.origin.y = self.statusBarView.frame.origin.y + 42
            }) { (finished) in
                
            }
        }
    }
}


// CHECK CONNECTION STATUS

extension HomeViewController{
    
    func initialConnectionCheck(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.networkStatusChanged(_:)), name: NSNotification.Name(ReachabilityStatusChangedNotification), object: nil)
        NetworkHelper().monitorReachabilityChanges()
    }
    
    @objc func networkStatusChanged(_ Notification: NSNotification){
        let status = NetworkHelper().connectionStatus()
        print(status)
        
        switch status {
        case .offline:
            if (self.isOffline == false)
            {
                self.isOffline = true
                self.setStatusBar(status: false)
            }
        case .online(.wwan), .unknown:
            self.fetchFromCK()
        case .online(.wiFi):
            if (self.isOffline == true)
            {
                self.isOffline = false
                self.setStatusBar(status: true)
            }
            self.fetchFromCK()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let activity = activities[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCollectionViewCell
        
        cell.layer.borderWidth = 10.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 20
        
        cell.setActivity(activity: activity)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape
        {
            return CGSize(width: self.collectionView.frame.width/2-10, height: 30)
        }
        else
        {
            return CGSize(width: self.collectionView.frame.width/1-10, height: 30)
        }
    }
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
        collectionView.reloadData()
    }
    
    func addActivity(activity: Activity) {
        activities.append(activity)
        self.sortActivities()
        self.saveActivityToCK(addedActivity: activity)
        collectionView.reloadData()
    }
    
    func deleteActivity(activity: Activity, index: Int) {
        activities.remove(at: index)
        collectionView.reloadData()
    }
}
