//
//  Nav+Animator.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/3/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    func preferredAnimator()->NavAnimatorClass{
        return NavAnimators.SlideLeft()
    }
    
    func animatorKey(for controller:UIViewController, withNavigator navigator:NavigatorType)->String{
        return "anim.\(pointerKey(controller)).\(navigator.rawValue)"
    }
    
    
    func setPreferredAnimator(_ animator:NavAnimatorClass? ,for controller:UIViewController, withNavigator navigator:NavigatorType){
        let key = animatorKey(for:controller, withNavigator: navigator)
        if animator != nil {
            animators[key] = animator
        }else {
            animators[key] = preferredAnimator()
        }
        
        
        animators[key]?.isNavTransition = true
    }
    
    func takeAnimator(for controller:UIViewController, withNavigator navigator:NavigatorType)->NavAnimatorClass?{
        let key = animatorKey(for:controller, withNavigator: navigator)
        guard let animator = animators[key] else{
            return nil
        }
        animators[key] = nil
        return animator
    }
  
   
    
}
