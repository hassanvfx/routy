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
            
            startOperationFor(navOperation: navOperation) { [weak self, weak navOperation] (flaskOperation) in
                self?.displayNav()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    navOperation?.releaseFlux()
                })
            }
            
        } else if  NavLayer.IsTab(substance.state.layerActive){
            let index = NavLayer.TabIndex(substance.state.layerActive)
            
            startOperationFor(navOperation: navOperation) { [weak self, weak navOperation] (flaskOperation) in
                self?.displayTab(index)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    print("pending operations for queue =\(String(describing: self?.operationQueue.operations.count))")
                    navOperation?.releaseFlux()
                    print("pending operations for queue =\(String(describing: self?.operationQueue.operations.count))")
                })
            }
            
        } else if NavLayer.IsModal(substance.state.layerActive){
//            let index = NavLayer.ModalIndex(substance.state.layerActive)
            //TODO: handle this
        }
        
        
        
    }
    
}

extension FlaskNav {
    
    func activeRootController()->UIViewController?{
        return navController?.viewControllers.first
    }
    
    func activeRootContext()->NavContext?{
        let controller = activeRootController()
        let context = NavStack.rootContext
        context.setWeak(viewController: controller)
        return context
    }
    
    func navigateRoot(navOperation:FlaskNavOperation){
        //TODO: animated parametrization?
        let rootContext = activeRootContext()
        startOperationFor(context:rootContext!,navOperation: navOperation) {[weak self] (operation) in
            DispatchQueue.main.async {
                self?.navController?.popToRootViewController(animated:true)
            }
        }
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
            navigateRoot(navOperation: navOperation)
        case .Pop:
            navigatePop(toContext:context,navOperation:navOperation)
        case .Push:
            navigatePush(context:context, navOperation:navOperation)
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
                context.setWeakViewController()
                
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
        context.setStrong(viewController: controller)
        
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
