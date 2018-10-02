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
    func applyNavType(fluxLock:FluxLock){
        
        
        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: substance.state.layerActive )
        
        if NavLayer.IsNav(substance.state.layerActive){
            
            performOperationFor(navOperation: navOperation) { [weak self, weak navOperation] (flaskOperation) in
                self?.displayNav()
            }
            
        } else if  NavLayer.IsTab(substance.state.layerActive){
            let index = NavLayer.TabIndex(substance.state.layerActive)
            
            performOperationFor(navOperation: navOperation) { [weak self, weak navOperation] (flaskOperation) in
                self?.displayTab(index)
            }
            
        } else if NavLayer.IsModal(substance.state.layerActive){
//            let index = NavLayer.ModalIndex(substance.state.layerActive)
            //TODO: handle this
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
    
    
    func navigateToController(layer:String,fluxLock:FluxLock){
        
        assert(substance.state.layers[layer] != nil, "layer is not defined!")
        
        let stringContext = substance.state.layers[layer]! as! String
        let context = NavContext.manager.context(fromStateHash:stringContext)
        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: context.operationName())
    
        let navigatorIntention = NavContext.manager.navigator(fromStateHash:stringContext)
        let navigator = resolveNavigatorFor(context: context, intention: navigatorIntention)
        
        instantiateViewControllerFor(context: context, navOperation: navOperation)
        
        print("--> will navigateTo \(context.path())")
        switch navigator {
        case .Root:
            navigateRoot(context:context, navOperation: navOperation)
        case .Pop:
            navigatePop(toContext:context,navOperation:navOperation)
        case .Push:
            navigatePush(context:context, navOperation:navOperation)
        }
        
       
    }
    
    
    func navigateRoot(context:NavContext, navOperation:FlaskNavOperation){
        //TODO: animated parametrization?
        let rootContext = activeRootContext(for: context.layer)
        performOperationFor(navOperation: navOperation) {[weak self] (operation) in
            self?.popToRoot(context:rootContext)
        }
    }
    
    func navigatePush(context:NavContext, navOperation:FlaskNavOperation){
       
        startOperationFor(context: context, navOperation: navOperation) {[weak self] (operation) in
            if let controller = context.viewController() {
                
                context.navigator = .Push
                
                self?.contextInitIntent(controller: controller, context: context)
                self?.setupEmptyStateIntent(controller: controller, context: context)
                self?.pushController(controller, context: context)
                self?.setupContentIntent(controller: controller, context: context, navOperation: navOperation)
                context.setViewControllerWeak()
                
            }else{
                assert(false,"controller unexpectedly dellocated")
            }
        }
    }
    
    func navigatePop(toContext context:NavContext, navOperation:FlaskNavOperation){
        startOperationFor(context: context, navOperation: navOperation) {[weak self] (operation) in
            if let controller = context.viewController() {
                
                context.navigator = .Pop
                
                self?.popToController(controller, context: context)
            }else{
                assert(false,"controller unexpectedly dellocated")
            }
        }
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
}
