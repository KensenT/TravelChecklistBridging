//
//  ActivityCell.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 26/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var remainingDays: UILabel!
    @IBOutlet weak var imageShown: UIImageView!
    
    func setActivity(activity: Activity){
        activityName.text = activity.name
        location.text = activity.location
        date.text = activity.date
        remainingDays.text = activity.remainingDays
        imageShown.image = UIImage(named: activity.image1)
    }
}
