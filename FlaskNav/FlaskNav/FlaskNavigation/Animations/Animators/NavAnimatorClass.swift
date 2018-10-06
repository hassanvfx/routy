//
//  NavAnimatorClass.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

open class NavAnimatorClass: NSObject {
    public private(set) var isPresented = false
    public private(set) var interactionController:UIPercentDrivenInteractiveTransition? = nil
    public var isNavTransition = false
    public var _duration = 0.4
    
    //MARK: subclass methods
    open func name()->String{
        return "animator"
    }
    open func present(controller:UIViewController,from fromController:UIViewController,in containerView:UIView, withContext context:UIViewControllerContextTransitioning){
        assert(false,"use a subclass instead")
    }
    open func dismiss(controller:UIViewController,to toController:UIViewController,in containerView:UIView, withContext context:UIViewControllerContextTransitioning){
        assert(false,"use a subclass instead")
    }
    
    open func _setParams(_ params:NSDictionary){
        assert(false,"use a subclass instead")
    }
    open func _getParams()->NSDictionary{
        assert(false,"use a subclass instead")
        return ["name":name,
                "duration":_duration]
    }
    
}

extension NavAnimatorClass:UIViewControllerAnimatedTransitioning{
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            else{
                assert(false,"invalid layer")
                return
        }
        
        
        let container = transitionContext.containerView
        
        if isPresented == false {
            isPresented = true
            present(controller: toController, from: fromController, in: container, withContext: transitionContext)
        }else{
            isPresented = false
            if isNavTransition {
                container.insertSubview(toController.view, belowSubview: fromController.view)
            }
            dismiss(controller: fromController, to: toController, in: container, withContext: transitionContext)
        }
    }
}

extension NavAnimatorClass{
    public func asParameter()->String{
        let params = _getParams()
        return NavSerializer.dictToString(params)
        
    }
    public func setParameters(_ string:String){
        let info = NavSerializer.stringToDict(string)
        _setParams(info)
    }
}

extension NavAnimatorClass{
    public func interactionStart(){
         interactionController = UIPercentDrivenInteractiveTransition()
    }
    
    public func interactionPercent()->Double{
        guard let controller = interactionController else {
            return 0
        }
        return Double(controller.percentComplete)
    }
    
    public func interactionUpdate(percent:Double){
        interactionController?.update(CGFloat(percent))
    }
    
    public func interactionCanceled(){
        interactionController?.cancel()
        interactionController = nil
    }
    
    public func interactionFinished(){
        interactionController?.finish()
        interactionController = nil
    }
}


