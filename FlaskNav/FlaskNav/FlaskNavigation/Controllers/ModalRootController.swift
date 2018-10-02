//
//  ModalRootController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/1/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

typealias ModalRootControllerTouch = ()->Void
class ModalRootController: UIViewController {
    
    var wasNavBarHidden:Bool = false
  
    func viewForwarder()->TouchForwardingView{
        return view as! TouchForwardingView
    }
    
    override func loadView() {
        view = TouchForwardingView()
        viewForwarder().touchChilds = false
        
//        NavDebug.shared.perform{
//            view.backgroundColor = .black
//            view.alpha = 0.25
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.isUserInteractionEnabled = false
        view.isHidden = false
        
        if let navController =  navigationController{
            wasNavBarHidden = navController.isNavigationBarHidden
            navController.setNavigationBarHidden(true, animated: false)
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let navController =  navigationController{
            navController.setNavigationBarHidden(wasNavBarHidden, animated: false)
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
