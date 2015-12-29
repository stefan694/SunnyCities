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
    var population:Int?
    var lat : Double!
    var lng: Double!
    var name:String!
    
    // test
    var weather: String!
    var temp: Double!
    
    init?(json:JSON) {
        // if any required field is missing we must not create the object.
        if let name = json["name"].string, cityId = json["id"].int, lat = json["coord"]["lat"].double,
        lng = json["coord"]["lon"].double {
            self.name = name
            self.cityId = cityId
            self.lat = lat
            self.lng = lng
        }else{
            return nil
        }
        
        // self.population = json["population"].int
        }
}
