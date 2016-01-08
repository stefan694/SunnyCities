//
//  CityInfo.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import CoreLocation
import Foundation

class CityInfo {
    var cityId: Int!
    var lat : Double!
    var lng: Double!
    var name:String!
    var weather: String!
    var temp: Int!
    var distance: Double!
    
    let locationManager = CLLocationManager.sharedManager
    var userLocation = CLLocation(latitude: 59.326354, longitude: 18.072310)
    
    // initialize object with json data
    init?(json:JSON) {
        // if any required field is missing or if weather is not clear we must not create the object.
        let weather = json["weather"][0]["main"].string
        if (weather == "Clear") {
            if let name = json["name"].string, cityId = json["id"].int, lat = json["coord"]["lat"].double,
                lng = json["coord"]["lon"].double {
                    
                    // set instance attributes
                    self.name = name
                    self.cityId = cityId
                    self.lat = lat
                    self.lng = lng
                    self.weather = weather
                    
                    // use location manager to cset the distance between each city and current location  of the user
                    let km = locationManager.location!.distanceFromLocation(CLLocation(latitude: lat, longitude: lng)) / 1000
                    let numberOfPlaces = 1.0
                    let multiplier = pow(10.0, numberOfPlaces)
                    let roundedKm = round(km * multiplier) / multiplier
                    self.distance = roundedKm
            }else{
                return nil
            }
            self.temp = json["main"]["temp"].int // set temperature (not required to create object)
        } else {
            return nil
        }
        
    }
}
