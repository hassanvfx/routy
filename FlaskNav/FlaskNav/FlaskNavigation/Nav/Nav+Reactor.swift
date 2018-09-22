//
//  Navigators.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav: FlaskReactor{
    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentController){[weak self] (change) in
            self?.navigateToCurrentController(fluxLock: reaction.onLock!)
        }
    }
}

extension FlaskNav {
    
    func activeRootController()->UIViewController?{
        return navController?.viewControllers.first
    }
    
    func navigateToRootView(navOperation:FlaskNavOperation){
        //TODO: animated parametrization?
        let rootController = activeRootController()
        startOperationFor(controller:rootController!,navOperation: navOperation) {[weak self] (operation) in
            DispatchQueue.main.async {
                self?.navController?.popToRootViewController(animated:true)
            }
        }
    }
    
    func navigateToCurrentController(fluxLock:FluxLock){
        
        let stringContext = navigation.state.currentController
        let context = NavigationContext(fromString: stringContext)
       
         let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: context.controller)
        
        print("--> navigation \(context.path())")
        guard context.controller != ROOT_CONTROLLER else{
            navigateToRootView(navOperation: navOperation)
            return
        }
        
        let controller = controllerFrom(context: context, navOperation:navOperation)

        startOperationFor(controller: controller, navOperation: navOperation) {[weak self] (operation) in
            
            self?.contextInitIntent(controller: controller, context: context)
            self?.navInitIntent(controller: controller, context: context)
            self?.pushController(controller, context: context)
            self?.asyncSetupIntent(controller: controller, context: context, navOperation: navOperation)
            
        }
        
        
    }
}
