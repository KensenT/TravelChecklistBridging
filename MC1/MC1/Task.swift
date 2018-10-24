//
//  Task.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 29/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import Foundation

class Task: NSObject{
    var name: String = ""
    var pic: String = ""
    var descriptions: String = ""
    var completed: Bool = false
    
    override init(){
    }
    
    init(name: String, pic: String, description: String, completed: Bool) {
        self.name = name
        self.pic = pic
        self.descriptions = description
        self.completed = completed
    }
}
