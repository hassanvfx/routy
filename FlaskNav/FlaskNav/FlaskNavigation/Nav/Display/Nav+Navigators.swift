//
//  Nav+Navigators.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask


extension FlaskNav {
    
    func navigateToController(layer:String,fluxLock:FluxLock){
        
        assert(substance.state.layers[layer] != nil, "layer is not defined!")
        
        let stringContext = substance.state.layers[layer]! as! String
        let context = NavContext.manager.context(fromStateHash:stringContext)
        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: context.operationName())
    
        let navigatorIntention = NavContext.manager.navigator(fromStateHash:stringContext)
        let navigator = resolveNavigatorFor(context: context, intention: navigatorIntention)
        
        instantiateViewControllerFor(context: context, navOperation: navOperation)
        
        print("--> will navigateTo \(context.desc())")
        switch navigator {
        case .Root:
//            setAnimatorFor(context:context,navigator: .Root)
            navigateRoot(context:context, navOperation: navOperation)
        case .Pop:
            setAnimatorFor(context:context,navigator: .Pop)
            navigatePop(toContext:context,navOperation:navOperation)
        case .Push:
            setAnimatorFor(context:context,navigator: .Push)
            navigatePush(context:context, navOperation:navOperation)
        }
        
       
    }
    
    
    func navigateRoot(context:NavContext, navOperation:FlaskNavOperation){
        //TODO: animated parametrization?
        startOperationFor(context: context, navOperation: navOperation) {[weak self] (operation) in
            self?.popToRoot(context:context)
        }
    }
    
    func navigatePush(context:NavContext, navOperation:FlaskNavOperation){
       
        startOperationFor(context: context, navOperation: navOperation) {[weak self] (operation) in
            guard let controller = context.viewController() else {
                assert(false,"controller unexpectedly dellocated")
                return
            }
            
            let nav = self?.navInstance(forLayer: context.layer)
            
            if (nav?.viewControllers.contains(controller))! {
                print("! aborting push \(context.desc())")
                DispatchQueue.main.async {
                    self?.intentToCompleteOperationFor(context: context)
                }
                return
            }
            
            context.navigator = .Push
            self?.contextInitIntent(controller: controller, context: context)
            self?.setupEmptyStateIntent(controller: controller, context: context)
            self?.pushController(controller, context: context)
            self?.setupContentIntent(controller: controller, context: context, navOperation: navOperation)
            context.setViewControllerWeak()
            
        }
    }
    
    func navigatePop(toContext context:NavContext, navOperation:FlaskNavOperation){
        startOperationFor(context: context, navOperation: navOperation) {[weak self] (operation) in
            guard let controller = context.viewController() else {
                assert(false,"controller unexpectedly dellocated")
                return
            }
                
            context.navigator = .Pop
            self?.popToController(controller, context: context)
            
        }
    }
}


extension FlaskNav {
    
    func activeRootController(for layer:String)->UIViewController?{
        let nav = navInstance(forLayer: layer)
        return nav.viewControllers.first
    }
    
    func activeRootContext(for layer:String)->NavContext{
        let controller = activeRootController(for:layer)
        let context = stack(forLayer: layer).rootContext
        context.setViewController(weak: controller)
        return context
    }
    
    
}

extension FlaskNav{
    
    func instantiateViewControllerFor(context:NavContext, navOperation:FlaskNavOperation){
       
        if context.viewController() != nil { return }
        let controller = controllerFrom(context: context, navOperation:navOperation)
        context.setViewController(strong: controller)
        
    }
    
    
    
    func resolveNavigatorFor(context:NavContext, intention:NavigatorType)->NavigatorType{
        
        if  context.viewController() == nil {
            // for example in a batch action
            // not all controllers are instantiated until navigation is performed
            // this may convert a Pop into a Push operation
            return .Push
        }
        return intention
    }
    
    func setAnimatorFor(context:NavContext, navigator:NavigatorType){
        
        print("setting future animator \(String(describing: context.animator)) for \(context.desc()) nav \(navigator.rawValue)")
        guard let controller = context.viewController() else { return }
       
        context.animator = context.animator ?? preferredAnimator()
            
        bindAnimatorCallbacks(context.animator!, controller:controller, context:context, navigator:navigator)
        setPreferredAnimator(context.animator!, for: controller, withNavigator: navigator)
    }
}
