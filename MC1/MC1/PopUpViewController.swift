//
//  PopUpViewController.swift
//  MC1
//
//  Created by Ferlix Yanto Wang on 29/04/18.
//  Copyright © 2018 Ferlix Yanto Wang. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
    }

    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
}
