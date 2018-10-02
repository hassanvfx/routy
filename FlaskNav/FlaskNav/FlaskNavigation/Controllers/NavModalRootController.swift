//
//  NavModalRootController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/1/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavModalRootController: UIViewController {
    
    var wasNavBarHidden:Bool = false
    
    override func loadView() {
        view = InactiveBackView()
        view.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController =  navigationController{
            wasNavBarHidden = navController.isNavigationBarHidden
            navController.setNavigationBarHidden(true, animated: false)
        }
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let navController =  navigationController{
            navController.setNavigationBarHidden(wasNavBarHidden, animated: true)
        }
    }
    
//    - (BOOL)prefersStatusBarHidden {
//    return NO;
//    }
//
//    - (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//    }
//
//    - (BOOL)shouldAutomaticallyForwardAppearanceMethods {
//    return YES;
//    }
}
