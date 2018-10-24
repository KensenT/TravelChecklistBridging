//
//  DetailViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 27/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var remainingTaskLabel: UILabel!
    @IBOutlet weak var completedTaskLabel: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var remainingDaysLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewOutlet: UIView!
    
    // MARK: - Properties
    var activity: Activity!
    var activityIndex = 0
    var taskIndex = 0
    var delegate: ActivityDataDelegate?
    
    var sortedTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityNameLabel.text = activity.name
        locationLabel.text = activity.location
        dateLabel.text = activity.date
        remainingDaysLabel.text = activity.remainingDays
        remainingTaskLabel.text = ("\(getRemainingNo()) remaining")
        completedTaskLabel.text = ("\(getCompletedNo()) completed")
        imageBackground.image = UIImage(named: activity.image2)
        
        
        viewOutlet.layer.cornerRadius = 10.0
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getCompletedNo() -> Int{
        return activity.remainingTask.filter({$0.completed == true}).count
    }
    
    func getRemainingNo() -> Int{
        return activity.remainingTask.filter({$0.completed == false}).count
    }
    
    func getSortedTasks(){
        self.sortedTasks.removeAll()
        self.sortedTasks = activity.remainingTask.filter({$0.completed == false}) + activity.remainingTask.filter({$0.completed == true})
        self.activity.remainingTask.removeAll()
        self.activity.remainingTask = self.sortedTasks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getSortedTasks()
        remainingTaskLabel.text = ("\(getRemainingNo()) remaining")
        completedTaskLabel.text = ("\(getCompletedNo()) completed")
        tableView.reloadData()
    }
    
    @IBAction func editButtonPressed() {
        performSegue(withIdentifier: "DetailToEdit", sender: self)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.remainingTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task: Task = activity.remainingTask[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        
        cell.setTask(task: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskIndex = indexPath.row
        performSegue(withIdentifier: "DetailToTaskDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskDetailViewController {
            
            destination.task = activity.remainingTask[taskIndex]
           
            destination.delegate = self
            destination.index = taskIndex
        } else if let destination = segue.destination as? AddNewTaskViewController{
                destination.delegate = self
        } else if let destination = segue.destination as? EditActivityViewController{
                destination.activity = activity
                destination.index = activityIndex
                destination.delegate = self
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}

extension DetailViewController: TaskDataDelegate {
    func editTask(task: Task, index: Int, completed: Bool?) {
        activity.remainingTask[index] = task
        viewWillAppear(true)
    }
    
    func deleteTask(task: Task, index: Int) {
        activity.remainingTask.remove(at: index)
        viewWillAppear(true)
    }
    
    func addTask(task: Task) {
        activity.remainingTask.append(task)
        viewWillAppear(true)
    }
}

extension DetailViewController: ActivityDataDelegate {
    
    func editActivity(activity: Activity, index: Int) {
        self.activity = activity
        activityNameLabel.text = activity.name
        locationLabel.text = activity.location
        dateLabel.text = activity.date
        remainingDaysLabel.text = activity.remainingDays
        imageBackground.image = UIImage(named: activity.image2)
        
        delegate?.editActivity(activity: activity, index: index)
    }
    
    func addActivity(activity: Activity) {
    }
    
    func deleteActivity(activity: Activity, index: Int) {
        self.delegate?.deleteActivity(activity: self.activity, index: self.activityIndex)
        self.navigationController?.popViewController(animated: true)
    }
}
