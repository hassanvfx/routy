//
//  Nav+Animator.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/3/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


extension FlaskNav {
    
    func preferredAnimator(for navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            
            let animator = self.getPreferredAnimator(for: toVC, withNavigator: .Push)
            
            animator.prepareForNavController()
            animator.prepareToShow()
            
            setPreferredRootAnimator(animator, for: fromVC, withNavigator: .Root, nav: navigationController)
            setPreferredAnimator(animator, for: toVC, withNavigator: .Pop)
            
            return animator
            
        }
        
        let rootAnimator = self.getPreferredAnimator(for: toVC, withNavigator: .Root)
        let popAnimator = self.getPreferredAnimator(for: fromVC, withNavigator: .Pop)
        let isRoot = isRootController(nav: navigationController, controller: toVC)
        let animator = isRoot ? rootAnimator : popAnimator
        
        animator.prepareForNavController()
        animator.prepareToHide()
        
        return animator
    }
}

extension FlaskNav{
    
    func preferredAnimator()->NavAnimatorClass{
        return NavAnimators.SlideLeft()
    }
    
    func animatorKey(for controller:UIViewController, withNavigator navigator:NavigatorType)->String{
        return "anim.\(pointerKey(controller)).\(navigator.rawValue)"
    }
    
    func isRootController(nav:UINavigationController,controller:UIViewController)->Bool{
        guard let root = nav.viewControllers.first else { return false}
        return  root == controller
    }

    func setPreferredRootAnimator(_ animator:NavAnimatorClass ,for controller:UIViewController, withNavigator navigator:NavigatorType, nav:UINavigationController){
        
        if !isRootController(nav:nav,controller:controller){ return }
        
        print("will Set animator for Root controller")
        setPreferredAnimator(animator,for:controller,withNavigator: navigator)
    }
    
    func setPreferredAnimator(_ animator:NavAnimatorClass ,for controller:UIViewController, withNavigator navigator:NavigatorType){
        let key = animatorKey(for:controller, withNavigator: navigator)
        print("setting animator for key \(key) - \(animator)")
        animators[key] = animator
    }
    

    
    func getPreferredAnimator(for controller:UIViewController, withNavigator navigator:NavigatorType)->NavAnimatorClass{
        let key = animatorKey(for:controller, withNavigator: navigator)
        print("getting animator for key \(key)")
        var animator = animators[key]
        if animator == nil {
            print("getting DEFAULT animator for key \(key)")
            animator = preferredAnimator()
        }
        return animator!
    }
    
    func removePreferredAnimator(for controller:UIViewController, withNavigator navigator:NavigatorType){
        let key = animatorKey(for:controller, withNavigator: navigator)
         print("removing animator for key \(key)")
         animators[key] = nil
    }

}


extension FlaskNav {
    
    func animatorKey(for layer:String, withType type:NavAnimatorClassType)->String{
        return "anim.\(layer).\(type.rawValue)"
    }
    
    func setActiveLayerAnimator(_ animator:NavAnimatorClass? ,for layer:String, withType type:NavAnimatorClassType){
        let key = animatorKey(for:layer, withType: type)
        print("setting animator for key \(key) - \(String(describing: animator))")
        if animator != nil {
            animators[key] = animator
        }else if type == .Show{
            animators[key] = preferredAnimator()
        }
        
    }
    
    func getActiveLayerAnimator(for layer:String, withType type:NavAnimatorClassType)->NavAnimatorClass?{
        let key = animatorKey(for:layer, withType: type)
        print("getting animator for key \(key)")
        return animators[key]
    }
    
    func removeActiveLayerAnimator(for layer:String, withType type:NavAnimatorClassType){
        let key = animatorKey(for:layer, withType: type)
        animators[key] = nil
    }
}


extension FlaskNav {
    
    func bindAnimatorCallbacks(_ animator:NavAnimatorClass?, controller:UIViewController, context:NavContext, navigator:NavigatorType){
        
        guard let animator = animator else { return }
        
        animator.onAnimationCompleted = { [weak self] completed in
            
            if completed && animator.type == .Hide {
                self?.removePreferredAnimator(for: controller, withNavigator: navigator)
                
            }else if !completed {
                DispatchQueue.main.async{
                    self?.intentToCompleteOperationFor(context: context, completed: false, intentRoot: navigator == .Push)
                }
                
            }
        }
        animator.onRequestDismiss = { [weak self]  (navGesture, gesture) in
            
            if gesture.state == .began {
                self?.popCurrent(layer: context.layer)
            }
        }
        
    }
}
