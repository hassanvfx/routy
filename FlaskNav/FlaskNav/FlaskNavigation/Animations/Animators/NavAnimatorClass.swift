//
//  NavAnimatorClass.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

open class NavAnimatorClass: NSObject, UIViewControllerAnimatedTransitioning {
    

    public var presenter = true
    public var _duration = 0.4
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      
        return _duration

    }

    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let container = transitionContext.containerView
 
        if presenter {
            present(controller: toController, from: fromController, in: container, withContext: transitionContext)
        }else{
            dismiss(controller: fromController, to: toController, in: container, withContext: transitionContext)
        }
    }
    
    func asParameter()->String{
        let params = getParameters()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            return String(data: jsonData, encoding: .utf8)!
        }catch{
            fatalError("Serialization error")
        }
    }
    func withParameters(_ params:String){
        
        do{
            let jsonData = params.data(using: .utf8)!
            let info = try JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            setParameters(info)
        }catch{
            fatalError("serialization error")
        }
    }
    
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
    
    open func setParameters(_ params:NSDictionary){
         assert(false,"use a subclass instead")
    }
    open func getParameters()->NSDictionary{
        assert(false,"use a subclass instead")
        return ["name":name,
                "duration":_duration]
    }
    
}


