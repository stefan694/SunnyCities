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
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    private var _cityInfo:CityInfo!
    var cityInfo:CityInfo {
        // get CityInfo instances (CityInfo.swift)
        get {
            return _cityInfo
        }
        
        // set the tableView cells labels
        set (cityInfo){
            self._cityInfo = cityInfo
            self.nameLabel.text = cityInfo.name
            self.distance.text = "\(cityInfo.distance) km"
            self.temperature.text = "\(cityInfo.temp)°"
            
            // display sun image if cell weather is Clear (kindof useless when you think about it because the array is already filtered in CityInfo.swift but hey you never know)
            if cityInfo.weather == "Clear"  {
                self.infoImage.image = UIImage(named: "sun")
            }
            
        }
    }
}
