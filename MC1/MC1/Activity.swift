//
//  Activity.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 26/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import Foundation

class Activity: NSObject{
    var name: String = ""
    var location: String = ""
    var category: String = ""
    var date: String = ""
    var remainingDays: String = ""
    var image1: String = ""
    var image2: String = ""
    var remainingTask: [Task] = [Task]()
    
    override init(){
    }
    
    init(name: String, location: String, category: String, date: String, remainingDays: String) {
        self.name = name
        self.location = location
        self.category = category
        self.date = date
        self.remainingDays = remainingDays
        
        // Preparing images based on category
        if self.category == "Mountain"{
            self.image1 = "mountain-l"
            self.image2 = "mountain-p"
        } else if self.category == "Beach"{
            self.image1 = "beach-l"
            self.image2 = "beach-p"
        }
        
        // Set Initial task based on category
        var task1 = Task()
        var task2 = Task()
        var task3 = Task()
        var task4 = Task()
        var task5 = Task()
        var task6 = Task()
        var task7 = Task()
        
        if self.category == "Mountain"{
            task1 = Task(name: "Tent", pic: User().username, description: "Enough for two people", completed: false)
            task2 = Task(name: "Raincoat", pic: User().username, description: "In case it is needed", completed: false)
            task3 = Task(name: "First-aid kit", pic: User().username, description: "In case of emergency", completed: false)
            task4 = Task(name: "Sleeping bag", pic: User().username, description: "More comfortable sleep", completed: false)
            task5 = Task(name: "40L Backpack", pic: User().username, description: "To store all the equipment", completed: false)
            task6 = Task(name: "Canned food", pic: User().username, description: "For emergency supplies", completed: false)
            task7 = Task(name: "Lighter", pic: User().username, description: "Produces fire easier", completed: false)
        } else if self.category == "Beach"{
            task1 = Task(name: "Sunscreen", pic: User().username, description: "To avoid sunburn", completed: false)
            task2 = Task(name: "Canned food", pic: User().username, description: "For emergency supplies", completed: false)
            task3 = Task(name: "Lighter", pic: User().username, description: "Produces fire easier", completed: false)
            task4 = Task(name: "Sleeping bag", pic: User().username, description: "Enough for two people", completed: false)
            task5 = Task(name: "First-aid kit", pic: User().username, description: "In case of emergency", completed: false)
            task6 = Task(name: "Plastic bag", pic: User().username, description: "To store wet clothes", completed: false)
            task7 = Task(name: "Baseball cap", pic: User().username, description: "To protect head from the heat", completed: false)
        }
        
        remainingTask.append(task1)
        remainingTask.append(task2)
        remainingTask.append(task3)
        remainingTask.append(task4)
        remainingTask.append(task5)
        remainingTask.append(task6)
        remainingTask.append(task7)
    }
}
