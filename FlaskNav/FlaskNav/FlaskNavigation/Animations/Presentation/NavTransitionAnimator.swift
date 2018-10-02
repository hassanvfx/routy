//
//  NavTransitionAnimator.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var presenter = true
    public var duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenter {
            present(using: transitionContext)
        }else{
            dismiss(using: transitionContext)
        }
    }
    
    open func present(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        toViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        toViewController.view.layer.shadowColor = UIColor.black.cgColor
        toViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toViewController.view.layer.shadowOpacity = 0.3
        toViewController.view.layer.cornerRadius = 4.0
        toViewController.view.clipsToBounds = true
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: animationDuration, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    
    open func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
        
}
