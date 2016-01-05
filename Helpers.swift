//
//  Helpers.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationManager{
    
    class var sharedManager : CLLocationManager {
        struct Singleton {
            static let instance = CLLocationManager()
        }
        return Singleton.instance
    }
}


func toUriEncoded(params: [String:String]) -> String {
    var records = [String]()
    for (key, value) in params {
        let valueEncoded = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        records.append("\(key)=\(valueEncoded!)")
    }
    return records.joinWithSeparator("&")
}


func M(completion: () -> () ) {
    dispatch_async(dispatch_get_main_queue(), completion)
}


func requestJSON(urlString:String, params:[String:String] = [:], completion:(JSON, NSError?) -> Void){
    let fullUrlString = "\(urlString)?\(toUriEncoded(params))"
    if let url = NSURL(string: fullUrlString) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil {
                completion(JSON(NSNull()), error)
                return
            }
            
            var jsonData = data!
            var jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)!
            
            // if it is the Flickr response we have to remove the callback function jsonFlickrApi()
            // from the JSON string
            if (jsonString as String).characters.startsWith("jsonFlickrApi(".characters) {
                jsonString = jsonString.substringFromIndex("jsonFlickrApi(".characters.count)
                let end = (jsonString as String).characters.count - 1
                jsonString = jsonString.substringToIndex(end)
                jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            }
            
            let json = JSON(data:jsonData)
            completion(json, nil)
            
            }.resume()
    }else {
        completion(JSON(NSNull()), ErrorFactory.error(.WrongInput))
    }
}
