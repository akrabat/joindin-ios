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
    
    var currentEventType = EventType.HOT_EVENTS

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
        
        var tableCell = tableView.dequeueReusableCellWithIdentifier("eventListCell") as EventListCell
        tableCell.eventNameLabel.text = "Event name here"
        tableCell.eventImageView.image = UIImage(named: "event_icon_none.gif")
        tableCell.layoutMargins = UIEdgeInsetsZero;
        tableCell.preservesSuperviewLayoutMargins = false;
        return tableCell
    }
    
    // UISegmentedControl: eventTypeSegmentControl
    
    @IBAction func eventTypeSelected(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case EventType.HOT_EVENTS.rawValue:
            currentEventType = EventType.HOT_EVENTS
            eventTableView.reloadData()
            
        case EventType.UPCOMING_EVENTS.rawValue:
            currentEventType = EventType.UPCOMING_EVENTS
            eventTableView.reloadData()
            
        case EventType.PAST_EVENTS.rawValue:
            currentEventType = EventType.PAST_EVENTS
            eventTableView.reloadData()
            
        default:
            println("Unknown segment index \(sender.selectedSegmentIndex)")
        }
    }
}

