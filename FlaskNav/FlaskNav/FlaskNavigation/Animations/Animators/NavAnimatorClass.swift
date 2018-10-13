//
//  NavAnimatorClass.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public enum NavAnimatorClassType: String{
    case Show,Hide
}
public enum NavAnimatorControllerType: String{
    case Navigation,ViewController
}

public typealias NavAnimatorInteraction = (_ interactor: NavAnimatorClass)->Void

open class NavAnimatorClass: NSObject {
    public private(set) var type:NavAnimatorClassType = .Show
    public private(set) var controller:NavAnimatorControllerType = .ViewController
    public var _duration = 0.4
    
    //MARK: INTERACTOR
    public var onInteractionRequest:NavAnimatorInteraction?
    var onInteractionCanceled:NavAnimatorInteraction?
    public weak var navContext:NavContext?
    public private(set) var _interactionController:UIPercentDrivenInteractiveTransition? = nil
    
   //MARK: SUBCLASS OVERRIDES
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
        return ["duration":_duration]
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
        
        if type == .Show {
            container.addSubview(toController.view)
            present(controller: toController, from: fromController, in: container, withContext: transitionContext)
        } else if type == .Hide{
            
            if controller == .Navigation {
                container.insertSubview(toController.view, belowSubview: fromController.view)
            }
            
            dismiss(controller: fromController, to: toController, in: container, withContext: transitionContext)
        }
    }
}

extension NavAnimatorClass{
    
    public func interactionStart()->UIPercentDrivenInteractiveTransition? {
        guard let onInteractionRequest = onInteractionRequest else { return nil }
        
        _interactionController = UIPercentDrivenInteractiveTransition()
        onInteractionRequest(self)
        
        return _interactionController
        
    }
    
    public func interactionPercent()->Double{
        guard let interactor = _interactionController else { return 0 }
        return Double(interactor.percentComplete)
    }
    
    public func interactionUpdate(percent: Double){
        _interactionController?.update(CGFloat(percent))
    }
    
    public func interactionCanceled(){
        autoreleasepool(){
            _interactionController?.cancel()
            _interactionController = nil
            
            if let onCancel = onInteractionCanceled {
                DispatchQueue.main.async {
                    onCancel(self)
                }
            }
        }
        
    }
    
    public func interactionFinished(){
        _interactionController?.finish()
        _interactionController = nil
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

    open func prepareToShow(){
        type = .Show
    }
    open func prepareToHide(){
        type = .Hide
    }
    open func prepareForNavController(){
        controller = .Navigation
    }
    
    open func prepareForViewController(){
        controller = .ViewController
    }
}


