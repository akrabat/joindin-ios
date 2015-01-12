//
//  ViewController.swift
//  joind.in
//
//  Created by Rich Sage on 02/01/2015.
//  Copyright (c) 2015 joind.in. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventTypeSegmentControl: UISegmentedControl!
    
    var currentEventType = EventType.HOT_EVENTS

    var events:[JoindInEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        updateEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEventDetail" {
            let selectedCell = sender as UITableViewCell
            let eventDetailVC = segue.destinationViewController as EventDetailViewTabBarController
            let indexPath = eventTableView.indexPathForCell(selectedCell)!
            eventDetailVC.event = events[indexPath.row]
        }
    }

    func updateEvents() {
        var ji = JoindInAPI()
        ji.getEvents(currentEventType, responseHandler: {(error: NSError?, result: Array<JoindInEvent>) in
            if error != nil {
                println(error)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.events = result
                self.eventTableView.reloadData()
            });
        })
    }

    // UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCellWithIdentifier("eventListCell") as EventListCell

        let thisEvent:JoindInEvent = self.events[indexPath.row]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMM yy"

        // Populate the table cell with the event's basic information
        tableCell.eventNameLabel.text = thisEvent.eventName
        let dateStr = (thisEvent.startDate != nil ? dateFormatter.stringFromDate(thisEvent.startDate!) : "")
        tableCell.eventDateLabel.text = dateStr
        if let iconStr = thisEvent.icon {
            // We've got an icon, load the image data
            let strURL = NSData(contentsOfURL: NSURL(string: "https://joind.in/inc/img/event_icons/\(iconStr)")!, options: nil, error: nil)
            if strURL != nil {
                tableCell.eventImageView.image = UIImage(data: strURL!)
            } else {
                tableCell.eventImageView.image = UIImage(named: "event_icon_none.gif")
            }
        } else {
            // No icon data supplied, use a default
            tableCell.eventImageView.image = UIImage(named: "event_icon_none.gif")
        }
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
            updateEvents()

        case EventType.UPCOMING_EVENTS.rawValue:
            currentEventType = EventType.UPCOMING_EVENTS
            updateEvents()

        case EventType.PAST_EVENTS.rawValue:
            currentEventType = EventType.PAST_EVENTS
            updateEvents()

        default:
            println("Unknown segment index \(sender.selectedSegmentIndex)")
        }
    }
}

