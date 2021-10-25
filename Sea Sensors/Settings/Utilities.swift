//
//  Utilities.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 3/28/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleViewLabel(_ label:UILabel) {
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .justified
        label.font = label.font.withSize(15)
        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
    }
    
    static func behindCardName(_ label:UILabel) {
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = label.font.withSize(16)
        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
    }
    
    static func behindCardView(_ view:UIView) {
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    }
    
    static func behindCardDesc(_ label:UILabel) {
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = label.font.withSize(14)
        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
        
    }
    
    static func bold(_ label:UILabel){
//        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .bold)
    }
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 203/255, green: 192/255, blue: 152/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)

    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    
}
