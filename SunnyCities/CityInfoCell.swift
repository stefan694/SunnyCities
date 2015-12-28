//
//  CityInfoCell.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import Foundation
import UIKit

class CityInfoCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    
    private var _cityInfo:CityInfo!
    var cityInfo:CityInfo {
        get {
            return _cityInfo
        }
        set (cityInfo){
            self._cityInfo = cityInfo
            self.nameLabel.text = cityInfo.name
            if let population = cityInfo.population {
                self.population.text = "Pop: \(population)"
            }else {
                self.population.text = ""
            }
            
            self.coordinates.text = String(format: "%.02f, %.02f", cityInfo.lat, cityInfo.lng)
            
            if let _ = cityInfo.wikipedia  {
                self.infoImage.image = UIImage(named: "info")
            }
        }
    }
}