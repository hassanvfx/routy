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
        return NavAnimators.ZoomIn()
    }
    
    func getAnimator(for controller:UIViewController)->NavAnimatorClass?{
        return  animators[pointerKey(controller)]
    }
    
    func setPreferredAnimator(_ animator:NavAnimatorClass? ,for controller:UIViewController){
       let key = pointerKey(controller)
        if animator != nil {
            animators[key] = animator
        }else {
            animators[key] = preferredAnimator()
        }
        animators[key]?.isNavTransition = true
    }
    
    @discardableResult
    func takeAnimator(for controller:UIViewController)->NavAnimatorClass?{
        let animator = animators[pointerKey(controller)]
        animators[pointerKey(controller)] = nil
        return animator
    }
}
