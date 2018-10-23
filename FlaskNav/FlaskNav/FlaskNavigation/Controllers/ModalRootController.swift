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
    
    var config:NavConfig?
    var wasNavBarHidden:Bool = false
  
    func viewForwarder()->TouchForwardingView{
        return view as! TouchForwardingView
    }
    
    override func loadView() {
        view = TouchForwardingView()
        viewForwarder().touchChilds = false
        
        NavDebug.shared.perform{
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isUserInteractionEnabled = false
        guard let navController = navigationController else { return }
        
        print("\(navController.viewControllers.count)")
        navController.setNavigationBarHidden(true, animated: true)
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let navController = navigationController else { return }
        guard let config = config else { return }
        
        navController.setNavigationBarHidden(!config.navBar, animated: config.navBarAnimated)
       
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
