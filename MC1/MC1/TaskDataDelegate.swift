//
//  TaskDataDelegate.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 01/05/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import Foundation

protocol TaskDataDelegate {
    func addTask(task: Task)
    func editTask(task: Task, index: Int, completed: Bool?)
    func deleteTask(task: Task, index: Int)
}
