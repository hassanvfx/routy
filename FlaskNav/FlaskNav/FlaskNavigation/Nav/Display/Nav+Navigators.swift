//
//  Nav+Navigators.swift
//  Roots
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension Roots {
    func applyNavType(fluxLock:FluxLock){
        
        let style = navigation.state.navType
        
        print("style = \(style)")
        let tabIndex = navigation.state.currentTab
         
        let navOperation = RootsOperation(fluxLock: fluxLock, name: style.rawValue )
        
        switch(style){
        case .NAV:
            startOperationFor(navOperation: navOperation) { [weak self, weak navOperation] (flaskOperation) in
                self?.displayNav()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    navOperation?.releaseFlux()
                })
            }
        case .TAB:
            startOperationFor(navOperation: navOperation) { [weak self, weak navOperation] (flaskOperation) in
                self?.displayTab(tabIndex)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    print("pending operations for queue =\(self?.operationQueue.operations.count)")
                    navOperation?.releaseFlux()
                    print("pending operations for queue =\(self?.operationQueue.operations.count)")
                })
            }
        }
        
        
         
//            switch(style){
//            case .NAV:
//                self?.displayNav()
//            case .TAB:
//                self?.displayTab(tabIndex)
//            }
        
        
            
//        }
        
        
    }
    
}

extension Roots {
    
    func activeRootController()->UIViewController?{
        return navController?.viewControllers.first
    }
    
    func navigateToRootView(navOperation:RootsOperation){
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
        let context = NavContext(fromString: stringContext)
        
        let navOperation = RootsOperation(fluxLock: fluxLock, name: context.controller)
        
        print("--> navigation \(context.path())")
        guard context.controller != ROOT_CONTROLLER else{
            navigateToRootView(navOperation: navOperation)
            return
        }
        
        let controller = controllerFrom(context: context, navOperation:navOperation)
        
        startOperationFor(controller: controller, navOperation: navOperation) {[weak self] (operation) in
            
            self?.contextInitIntent(controller: controller, context: context)
            self?.setupEmptyStateIntent(controller: controller, context: context)
            self?.pushController(controller, context: context)
            self?.setupContentIntent(controller: controller, context: context, navOperation: navOperation)
            
        }
        
        
    }
}
