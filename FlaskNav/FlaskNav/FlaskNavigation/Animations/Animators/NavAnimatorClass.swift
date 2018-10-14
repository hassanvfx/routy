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
public typealias NavGestureChange = (_ navGesture: NavGestureAbstract, _ gesture:UIGestureRecognizer)->Void

open class NavAnimatorClass: NSObject {
    
    static let WAIT_FOR_ANIMATOR_TO_CANCEL = 0.5
    
    public private(set) var type:NavAnimatorClassType = .Show
    public private(set) var controller:NavAnimatorControllerType = .ViewController
    public var _duration = 0.4
    var viewAnimator:UIViewPropertyAnimator?
    
    //MARK: INTERACTOR
    public var onInteractionRequest:NavAnimatorInteraction?
    var onInteractionCanceled:NavAnimatorInteraction?
    public private(set) var _interactionController:UIPercentDrivenInteractiveTransition? = nil
    public private(set) var wasCanceled:Bool = false
    
    //MARK: GESTURES
    public var dismissGestures:[NavGestureAbstract] = []
    public private(set) var activeDismissGestures:[NavGestureAbstract] = []
    public var onRequestDismiss:NavGestureChange?
    
   //MARK: SUBCLASS OVERRIDES
    open func present(controller:UIViewController,from fromController:UIViewController,in containerView:UIView, withContext context:UIViewControllerContextTransitioning)->UIViewPropertyAnimator?{
        assert(false,"use a subclass instead")
    }
    open func dismiss(controller:UIViewController,to toController:UIViewController,in containerView:UIView, withContext context:UIViewControllerContextTransitioning)->UIViewPropertyAnimator?{
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
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        viewAnimator = nil
        
        if !transitionCompleted {
            onInteractionCanceled?(self)
        }
        
        removeActiveDismissGestures()
            
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _duration
    }
  
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        if let viewAnimator = self.viewAnimator {
            return viewAnimator
        }
        
        let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let container = transitionContext.containerView
        
        if type == .Show {
            container.addSubview(toController.view)
            addGesturesTo(view: toController.view)
            
            viewAnimator = present(controller: toController, from: fromController, in: container, withContext: transitionContext)
        } else if type == .Hide{
            
            
            if controller == .Navigation {
                container.insertSubview(toController.view, belowSubview: fromController.view)
            }
            
            viewAnimator = dismiss(controller: fromController, to: toController, in: container, withContext: transitionContext)
        }
        return viewAnimator!
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
}

extension NavAnimatorClass{
    
    public func interactionStart()->UIPercentDrivenInteractiveTransition? {
        guard  (onInteractionRequest != nil) || !activeDismissGestures.isEmpty else { return nil }
        
        _interactionController = UIPercentDrivenInteractiveTransition()
        onInteractionRequest?(self)
        
        return _interactionController
        
    }
    
    public func interactionPercent()->Double{
        guard let interactor = _interactionController else { return 0 }
        return Double(interactor.percentComplete)
    }
    
    public func interactionUpdate(percent: Double){
        DispatchQueue.main.async {
            self._interactionController?.update(CGFloat(percent))
        }
        
    }
    
    public func interactionCanceled(){
        wasCanceled = true
        _interactionController?.cancel()
        _interactionController = nil
        
    }
    
    public func interactionFinished(){
        _interactionController?.finish()
        _interactionController = nil
    }
}


extension NavAnimatorClass{
 
    func dissmisGestureStarted(_ navGesture:NavGestureAbstract, gesture:UIGestureRecognizer){
    
        onRequestDismiss?(navGesture, gesture)
    }
    
    func addGesturesTo(view:UIView){
        activeDismissGestures = []
        for navGesture in dismissGestures {
            activeDismissGestures.append(navGesture)
            navGesture.addTo(view: view, animator:self)
            
        }
        dismissGestures = []
    }
    
    func removeActiveDismissGestures(){
        if self.type != .Hide { return }
        
        for navGesture in activeDismissGestures {
            navGesture.removeFromView()
        }
        activeDismissGestures = []
    
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


