//
//  AboutUs.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 3/25/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {
    
    @IBOutlet var heightConstant: NSLayoutConstraint!
    
    @IBOutlet var aboutThisAppLabel: UILabel!
    @IBOutlet var firstBlock: UIView!
    @IBOutlet var secondBlock: UIView!
    @IBOutlet var thirdBlock: UIView!
    @IBOutlet var fourthBlock: UIView!
    @IBOutlet var fifthBlock: UIView!
    @IBOutlet var sixthBlock: UIView!
    @IBOutlet var seventhBlock: UIView!
    
    var heightValue:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstBlock.layoutIfNeeded()
        secondBlock.layoutIfNeeded()
        thirdBlock.layoutIfNeeded()
        fourthBlock.layoutIfNeeded()
        fifthBlock.layoutIfNeeded()
        sixthBlock.layoutIfNeeded()
        seventhBlock.layoutIfNeeded()
        
        heightValue += firstBlock.bounds.size.height
        heightValue += secondBlock.bounds.size.height
        heightValue += thirdBlock.bounds.size.height
        heightValue += fourthBlock.bounds.size.height
        heightValue += fifthBlock.bounds.size.height
        heightValue += sixthBlock.bounds.size.height
        heightValue += seventhBlock.bounds.size.height
        
        heightConstant.constant = heightValue + 165

    }

}
