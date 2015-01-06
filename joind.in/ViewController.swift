//
//  ViewController.swift
//  joind.in
//
//  Created by Rich Sage on 02/01/2015.
//  Copyright (c) 2015 joind.in. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventTypeSegmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("eventListCell") as UITableViewCell
    }
    
    // UISegmentedControl: eventTypeSegmentControl
    
    @IBAction func eventTypeSelected(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            println("Hot events")
        case 1:
            println("Upcoming events")
        case 2:
            println("Past events")
        default:
            println("Unknown segment index \(sender.selectedSegmentIndex)")
        }
    }
}

