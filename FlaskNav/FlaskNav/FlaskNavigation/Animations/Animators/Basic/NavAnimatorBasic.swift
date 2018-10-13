//
//  NavAnimatorBasic.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

protocol RawInitializable{
    init?(rawValue:String)
}


class NavAnimatorBasic<STYLE:RawRepresentable & RawInitializable>: NavAnimatorClass {
    
    var _intensity:Double
    var _style:STYLE
    
    init(style:STYLE, intensity:Double? = nil){
        _style = style
        _intensity = intensity ?? 0.5
    }

   
    
    open func applyTransformStyle(controller:UIViewController, parent:UIViewController,in containerView:UIView){}
    open func preferredIntensity()->Double{return _intensity}

    
    override open func _setParams(_ params:NSDictionary){
        if let aStyle = params["style"] as? String{
            _style = STYLE.init(rawValue:aStyle) ?? _style
        }
        if let aDuration = params["duration"] as? Double{
            _duration = aDuration
        }
        
        if let aItensity = params["intensity"] as? Double{
            _intensity = aItensity
        }
    }
    override open func _getParams()->NSDictionary{
        return [
            "style":_style.rawValue,
            "intensity":_intensity,
            "duration":_duration
        ]
    }
    
    override func present(controller:UIViewController,from fromController:UIViewController,in containerView:UIView, withContext context:UIViewControllerContextTransitioning){
        
        let animationDuration = transitionDuration(using: context)
        
        applyTransformStyle(controller: controller, parent: fromController, in: containerView)
        
        let animations = {
            controller.view.transform = CGAffineTransform.identity
            controller.view.alpha = 1
        }
            
        let completion = { (finished:UIViewAnimatingPosition) in
            context.completeTransition(!context.transitionWasCancelled)
        }
    
        let viewAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear, animations: animations)
        viewAnimator.addCompletion(completion)
        viewAnimator.startAnimation()
    }
    override func dismiss(controller:UIViewController,to toController:UIViewController,in containerView:UIView, withContext context:UIViewControllerContextTransitioning){
        
        let animationDuration = transitionDuration(using: context)
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.applyTransformStyle(controller: controller, parent: toController, in: containerView)
        
            
        }) { finished in
            context.completeTransition(!context.transitionWasCancelled)
        }
    }

}
