//
//  EventDetailViewController.swift
//  joind.in
//
//  Created by Rich Sage on 09/01/2015.
//  Copyright (c) 2015 joind.in. All rights reserved.
//

import UIKit

class EventDetailViewTabBarController: UITabBarController {

    var event:JoindInEvent? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if event == nil {
            // Can't continue, we need an event
            self.navigationController?.popViewControllerAnimated(true)
        }

        title = event?.eventName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
