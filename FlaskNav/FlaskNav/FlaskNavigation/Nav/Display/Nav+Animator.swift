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
        
        if let animator = self.getPreferredAnimator(for: toVC, withNavigator: .Push){
            
            animator.prepareForNavController()
            animator.prepareToShow()
            
            setPreferredAnimator(animator, for: fromVC, withNavigator: .Root)
            setPreferredAnimator(animator, for: toVC, withNavigator: .Pop)
            
            return animator
            
        }  else if let animator = self.getPreferredAnimator(for: toVC, withNavigator: .Root){
            
            animator.prepareForNavController()
            animator.prepareToHide()
            
            return animator
            
        }else if let animator = self.getPreferredAnimator(for: fromVC, withNavigator: .Pop){
            
            animator.prepareForNavController()
            animator.prepareToHide()
            
            return animator
        }
        
        assert(false, "error all cases should be handled")
        return nil
        
    }
}

extension FlaskNav{
    
    func preferredAnimator()->NavAnimatorClass{
        return NavAnimators.SlideLeft()
    }
    
    func animatorKey(for controller:UIViewController, withNavigator navigator:NavigatorType)->String{
        return "anim.\(pointerKey(controller)).\(navigator.rawValue)"
    }

    func setPreferredAnimator(_ animator:NavAnimatorClass ,for controller:UIViewController, withNavigator navigator:NavigatorType){
        let key = animatorKey(for:controller, withNavigator: navigator)
        print("setting animator for key \(key)")
        animators[key] = animator
    }
    
    func getPreferredAnimator(for controller:UIViewController, withNavigator navigator:NavigatorType)->NavAnimatorClass?{
        let key = animatorKey(for:controller, withNavigator: navigator)
        print("getting animator for key \(key)")
        return animators[key]
    }
    
    func removePreferredAnimator(for controller:UIViewController, withNavigator navigator:NavigatorType){
        let key = animatorKey(for:controller, withNavigator: navigator)
         print("removing animator for key \(key)")
//         animators[key] = nil
    }

}


extension FlaskNav {
    
    func animatorKey(for layer:String, withType type:NavAnimatorClassType)->String{
        return "anim.\(layer).\(type.rawValue)"
    }
    
    func setActiveLayerAnimator(_ animator:NavAnimatorClass? ,for layer:String, withType type:NavAnimatorClassType){
        let key = animatorKey(for:layer, withType: type)
        if animator != nil {
            animators[key] = animator
        }else if type == .Show{
            animators[key] = preferredAnimator()
        }
        
    }
    
    func getActiveLayerAnimator(for layer:String, withType type:NavAnimatorClassType)->NavAnimatorClass?{
        let key = animatorKey(for:layer, withType: type)
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
