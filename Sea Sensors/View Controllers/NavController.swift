//
//  NavController.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 3/21/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit

// For navigation controller which allows navigation between tabs and pages
class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
}
