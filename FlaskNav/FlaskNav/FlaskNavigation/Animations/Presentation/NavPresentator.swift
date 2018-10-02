//
//  NavPresentator.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavPresentator:NSObject {
    
    var animator:NavTransitionAnimator
    var presentation:NavPresentationController
    
    weak var presented:UIViewController!
    weak var presenting:UIViewController!
    
    init(presentViewController presented:UIViewController,
         from presenting:UIViewController,
         animator:NavTransitionAnimator? = nil,
         presentation:NavPresentationController? = nil){
        
        self.presented = presented
        self.presenting = presenting
        self.animator = animator ?? NavTransitionAnimator()
        self.presentation = presentation ?? NavPresentationController(presentedViewController: presented, presenting: presenting)
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
extension NavPresentator:UIViewControllerTransitioningDelegate{
   
    func presentationController(forPresentedViewController presented: UIViewController,
                                presenting: UIViewController?,
                                sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return presentation
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


