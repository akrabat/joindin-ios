//
//  joindInAPI.swift
//  joind.in
//
//  Created by Rich Sage on 09/01/2015.
//  Copyright (c) 2015 joind.in. All rights reserved.
//

import Foundation

class JoindInAPI {
    
    let METHOD_POST:String = "POST"
    let METHOD_DELETE:String = "DELETE"
    
    enum Status:Int {
        case OK = 0
        case ERROR = 1
    }

    // Public methods

    func getEvents(eventType: EventType, responseHandler: (error: NSError?, result: [JoindInEvent]) -> ()) {
        var filter = ""
        switch eventType.rawValue {
        case EventType.HOT_EVENTS.rawValue:
            filter = "hot"
        case EventType.UPCOMING_EVENTS.rawValue:
            filter = "upcoming"
        case EventType.PAST_EVENTS.rawValue:
            filter = "past"
        default:
            filter = "upcoming"
        }
        getJSONFullURI("https://api.joind.in/v2.1/events?filter=\(filter)", responseHandler: {(error: NSError?, result: JSON?) in
            var arr:[JoindInEvent] = []

            if error != nil {
                responseHandler(error: error, result: arr)
                return
            }
            if result == nil {
                responseHandler(error: nil, result: arr)
                return
            }

            let result = result!
            // Convert returned JSON data into JoindInEvent objects and then return accordingly
            for (index:String, eventJSON:JSON) in result["events"] {
                var event = JoindInEvent()

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"

                event.uri = NSURL(string: eventJSON["uri"].string!)
                event.eventName = eventJSON["name"].string!
                event.startDate = eventJSON["start_date"].string != nil ? dateFormatter.dateFromString(eventJSON["start_date"].string!) : nil
                event.endDate = eventJSON["end_date"].string != nil ? dateFormatter.dateFromString(eventJSON["end_date"].string!) : nil
                event.description = eventJSON["description"].string!
                event.href = eventJSON["href"].string
                event.tzContinent = eventJSON["tz_continent"].string!
                event.tzPlace = eventJSON["tz_place"].string!
                event.icon = eventJSON["icon"].string

                arr.append(event)
            }

            responseHandler(error: nil, result: arr)
        })
    }

    // Private methods
    
    private func getJSONFullURI(fullURI: String!, responseHandler: (error:NSError?, result:JSON?) -> ()) -> Void {
        var error:NSError?
        var request = getURLRequest(fullURI)
        
        var queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in

            if error != nil {
                // Error requesting URL
                responseHandler(error: error, result: nil)
                return
            }
            
            // parse json
            var jsonParseError:NSError?
            let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: &jsonParseError)
            
            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode != 200 {
                var dict = NSMutableDictionary()
                dict.setValue(json.object, forKey: "json")
                var responseError:NSError = NSError(domain: "in.joind.api_error", code: httpResponse.statusCode, userInfo: dict)
                responseHandler(error: responseError, result: nil)
                return
            }
            
            responseHandler(error: jsonParseError?, result: json)
        })
    }
    
    private func requestToFullURI(fullURI: String!, json: NSDictionary!, method: String!, responseHandler: (error:NSError?, result:JSON?) -> ()) {
        var request = getURLRequest(fullURI)
        
        if method == METHOD_POST {
            request.HTTPMethod = method
            if json.count > 0 {
                var error:NSError?
                var jsonData = NSJSONSerialization.dataWithJSONObject(json as NSDictionary, options: NSJSONWritingOptions.allZeros, error: &error)
                request.HTTPBody = jsonData
            }
            
            doMethodRequest(request, responseHandler)
        }
        if method == METHOD_DELETE {
            request.HTTPMethod = method
            
            doMethodRequest(request, responseHandler)
        }
    }
    
    private func getURLRequest(fullURI: String!) -> NSMutableURLRequest {
        var request = NSMutableURLRequest(URL: NSURL(string: fullURI)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // TODO add authentication details if required
        
        request.timeoutInterval = NSTimeInterval(30) // 30 seconds
        
        return request
    }
    
    private func doMethodRequest(request: NSURLRequest, responseHandler: (error:NSError?, result:JSON?) -> ()) {
        var queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                // Error requesting URL
                responseHandler(error: error, result: nil)
                return
            }
            
            // parse json
            var jsonParseError:NSError?
            let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: &jsonParseError)
            
            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode != 200 {
                var dict = NSMutableDictionary()
                dict.setValue(json.object, forKey: "json")
                var responseError:NSError = NSError(domain: "in.joind.api_error", code: httpResponse.statusCode, userInfo: dict)
                responseHandler(error: responseError, result: nil)
                return
            }
            
            responseHandler(error: jsonParseError?, result: json)
        })
    }
}