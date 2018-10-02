//
//  NavTransitioner.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavTransitioner:NSObject {
    
    var animator:NavTransitionAnimator
    var presentator:NavTransitionPresentator
    
    weak var presented:UIViewController!
    weak var presenting:UIViewController!
    
    init(presentViewController presented:UIViewController,
         from presenting:UIViewController,
         animator:NavTransitionAnimator? = nil,
         presentator:NavTransitionPresentator? = nil){
        
        self.presented = presented
        self.presenting = presenting
        self.animator = animator ?? NavTransitionAnimator()
        self.presentator = presentator ?? NavTransitionPresentator(presentedViewController: presented, presenting: presenting)
    }
    
    func present(_ completion:@escaping ()->Void = {}){
        if presenting.presentedViewController == presented {
            return
        }
        
        presented.modalPresentationStyle = .custom
        presented.transitioningDelegate = self
        
        presenting.present(presented, animated: true, completion: completion)
    }
    
    func dismiss(_ completion:@escaping ()->Void = {}){
        if presenting.presentedViewController == nil {
            assert(false,"nothing to dismiss!")
            return;
        }
        
        presenting.dismiss(animated: true, completion: completion)
    }
}
extension NavTransitioner:UIViewControllerTransitioningDelegate{
   
    func presentationController(forPresentedViewController presented: UIViewController,
                                presenting: UIViewController?,
                                sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return presentator
    }
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenter = true
        return animator
    }
    
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenter = false
        return animator
    }
}


