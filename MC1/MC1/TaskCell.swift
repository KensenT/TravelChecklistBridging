//
//  TaskCell.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 30/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var picLabel: UILabel!
    
    func setTask(task: Task){
        taskNameLabel.text = task.name
        picLabel.text = task.pic
        
        if task.completed == true {
            statusLabel.text = "Completed"
            statusLabel.textColor = UIColor.init(red: 86/255, green: 188/255, blue: 56/255, alpha: 1)
        } else {
            statusLabel.text = "On going"
            statusLabel.textColor = UIColor.init(red: 212/255, green: 137/255, blue: 64/255, alpha: 1)
        }
    }
}
