//
//  NavModalRootController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/1/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

typealias NavModalRootControllerTouch = ()->Void
class NavModalRootController: UIViewController {
    
    var wasNavBarHidden:Bool = false
    var didTouch:NavModalRootControllerTouch? = {}
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        UIView.animate(withDuration: 2.0) {
            self.view.alpha = 0.2
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTouched(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didTouched(_:)))
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
    }
    
    @objc
    func didTouched(_ recognizer:UIGestureRecognizer){
        if let didTouch = didTouch{
            didTouch()
        }
        didTouch = nil
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
