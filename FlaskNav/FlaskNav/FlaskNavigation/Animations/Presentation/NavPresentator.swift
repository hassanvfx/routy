//
//  NavPresentator.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavPresentator:NSObject {
    
    var animator:NavAnimatorClass
    var presentation:NavPresentationClass
    
    weak var presented:UIViewController!
    weak var presenting:UIViewController!
    
    init(presentViewController presented:UIViewController,
         from presenting:UIViewController,
         animator:NavAnimatorClass? = nil,
         presentation:NavPresentationClass? = nil){
        
        self.presented = presented
        self.presenting = presenting
        self.animator = animator ?? NavAnimatorClass()
        self.presentation = presentation ?? NavPresentationClass(presentedViewController: presented, presenting: presenting)
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
            //assert(false,"nothing to dismiss!")
            completion()
            return;
        }
        
        presenting.dismiss(animated: true, completion: completion)
    }
}
extension NavPresentator:UIViewControllerTransitioningDelegate{
   
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        return presentation
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.prepareForViewController()
        animator.prepareToShow()
        return animator
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.prepareForViewController()
        animator.prepareToHide()
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        
        guard let animator = animator as? NavAnimatorClass else{ return nil }
        
        guard let interactor =  animator.interactionStart() else { return nil }
        
//        animator.onInteractionCanceled = { [weak self] _ in
//            guard let this = self else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now() + NavAnimatorClass.WAIT_FOR_ANIMATOR_TO_CANCEL){
//                this.intentToCompleteOperationFor(context: animator.navContext, completed: false)
//            }
//        }
        
        return interactor
    }
    
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        
        guard let animator = animator as? NavAnimatorClass else{ return nil }
        
        guard let interactor =  animator.interactionStart() else { return nil }
        
//        animator.onInteractionCanceled = { [weak self] _ in
//            guard let this = self else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now() + NavAnimatorClass.WAIT_FOR_ANIMATOR_TO_CANCEL){
//                                this.intentToCompleteOperationFor(context: animator.navContext, completed: false)
//            }
//        }
        
        return interactor
    }

}


