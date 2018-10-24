//
//  ViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 26/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        activities = createArray()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 57/255, green: 172/255, blue: 217/255, alpha: 1)
        
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
    
    func saveActivityToCK(activity: Activity){
        
    }
}

extension HomeViewController: ActivityDataDelegate {
    func editActivity(activity: Activity, index: Int) {
        activities[index] = activity
        tableView.reloadData()
    }
    
    func addActivity(activity: Activity) {
        activities.append(activity)
        self.saveActivityToCK(activity: activity)
        tableView.reloadData()
    }
    
    func deleteActivity(activity: Activity, index: Int) {
        activities.remove(at: index)
        tableView.reloadData()
    }
}
