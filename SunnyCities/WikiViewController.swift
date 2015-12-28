//
//  WikiViewController.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import UIKit
import Foundation

class WikiViewController:UIViewController {
    var cityInfo:CityInfo!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        let url:NSURL
        if let wikipediaInfo = self.cityInfo.wikipedia {
            url = NSURL(string: "http://\(wikipediaInfo)")!
        }else {
            url = NSURL(string:"http://en.wikipedia.org/w/index.php?search=\(self.cityInfo.name)")!
        }
        let request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
    }
    
}

