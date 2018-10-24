//
//  ActivityDataDelegate.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 01/05/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import Foundation

protocol ActivityDataDelegate {
    func addActivity(activity: Activity)
    func editActivity(activity: Activity, index: Int)
    func deleteActivity(activity: Activity, index: Int)
}
