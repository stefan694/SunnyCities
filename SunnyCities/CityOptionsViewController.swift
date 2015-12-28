//
//  CityOptionsViewController.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import Foundation

import UIKit

class CityOptionsViewController : UIPageViewController, UIPageViewControllerDataSource {
    private var cityViewControllers = [UIViewController]()
    var cityInfo:CityInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.doubleSided = false
        
        let wikiViewController = self.storyboard?.instantiateViewControllerWithIdentifier("wikicity") as! WikiViewController
        wikiViewController.cityInfo = self.cityInfo
        cityViewControllers.append(wikiViewController)
        
        self.setViewControllers([wikiViewController], direction: .Forward, animated: true) { (_) -> Void in
            return
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let position = cityViewControllers.indexOf( viewController) where position > 0{
            return cityViewControllers[position - 1]
        }
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let position = cityViewControllers.indexOf( viewController) where position < cityViewControllers.count - 1 {
            return cityViewControllers[position + 1]
        }
        return nil
    }
}