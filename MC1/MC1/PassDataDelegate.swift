//
//  PassDataDelegate.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 29/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import Foundation

protocol ActivityDataDelegate {
    func passActivity(activity: Activity, index: Int)
    func deleteActivity(activity: Activity, index: Int)
}
