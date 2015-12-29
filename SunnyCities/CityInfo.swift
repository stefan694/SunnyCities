//
//  CityInfo.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import Foundation

class CityInfo {
    var cityId: Int!
    var lat : Double!
    var lng: Double!
    var name:String!
    var weather: String!
    var temp: Int!
    var currentUserLat: Double!
    var currentUserLong: Double!
    var distance: Int!
    
    init?(json:JSON) {
        // if any required field is missing we must not create the object.
        let weather = json["weather"][0]["main"].string
        if (weather == "Clear") {
            if let name = json["name"].string, cityId = json["id"].int, lat = json["coord"]["lat"].double,
                lng = json["coord"]["lon"].double {
                    self.name = name
                    self.cityId = cityId
                    self.lat = lat
                    self.lng = lng
                    self.weather = weather
            }else{
                return nil
            }
            self.temp = json["main"]["temp"].int
        } else {
            return nil
        }
        
    }
}
