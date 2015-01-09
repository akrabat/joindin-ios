//
//  Event.swift
//  joind.in
//
//  Created by Rich Sage on 09/01/2015.
//  Copyright (c) 2015 joind.in. All rights reserved.
//

import Foundation

class JoindInEvent {
    init() { }

    var uri:NSURL!

    var eventName:String!
    var startDate:NSDate?
    var endDate:NSDate?
    var description:String?
    var href:String?

    var tzContinent:String!
    var tzPlace:String!
    var icon:String?
}