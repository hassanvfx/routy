//
//  Navigators.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav {
    
    func activeRootController()->UIViewController?{
        return navController?.viewControllers.first
    }
    
    func navigateToRootView(navLock:FlaskNavLock){
        //TODO: animated parametrization?
        let rootController = activeRootController()
        startOperationFor(controller:rootController!,navLock: navLock, name:"Root") {[weak self] (operation) in
            DispatchQueue.main.async {
                self?.navController?.popToRootViewController(animated:true)
            }
        }
    }
    
    func navigateToCurrentController(fluxLock:FluxLock){
        
        let stringContext = navigation.state.currentController
        let context = NavigationContext(fromString: stringContext)
        let navLock = FlaskNavLock(fluxLock: fluxLock)
        
        print("--> navigation \(context.path())")
        guard context.controller != ROOT_CONTROLLER else{
            navigateToRootView(navLock: navLock)
            return
        }
        
        let cache = cachedControllerFrom(context: context, navLock:navLock)
        

        startOperationFor(controller: cache.controller,navLock: navLock,name:context.controller) {[weak self] (operation) in
            if (cache.cached){
                self?.popToController(cache.controller,context: context)
            }else{
                self?.pushController(cache.controller, context: context)
            }
        }
        
        
    }
}
