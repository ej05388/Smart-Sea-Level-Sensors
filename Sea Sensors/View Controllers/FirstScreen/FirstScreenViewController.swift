//
//  FirstScreenViewController.swift
//  GTSeaLevelAPP
//
//  Created by Johnson Amalanathan on 4/7/20.
//  Copyright © 2020 Georgia Tech. All rights reserved.
//

import UIKit
import Firebase

class FirstScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateUserAndConfigureView()
        
    }
    
    func authenticateUserAndConfigureView() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Overview", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Overview")
                
                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                let controller1 = storyboard1.instantiateViewController(withIdentifier: "MainViewController")
                controller.modalPresentationStyle = .fullScreen
                controller1.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false, completion: nil)
                self.present(controller1, animated: true, completion: nil)
                
            }
        } else {
            DispatchQueue.main.async {
//                let vc = UIViewController()
//                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//                self.present(vc, animated: true, completion: nil)
                
                
                let storyboard = UIStoryboard(name: "Overview", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Overview")
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

}
