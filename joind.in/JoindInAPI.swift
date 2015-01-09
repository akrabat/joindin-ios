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
    
    func getJSONFullURI(fullURI: String!, responseHandler: (error:NSError?, result:JSON?) -> ()) -> Void {
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
    
    func requestToFullURI(fullURI: String!, json: NSDictionary!, method: String!, responseHandler: (error:NSError?, result:JSON?) -> ()) {
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