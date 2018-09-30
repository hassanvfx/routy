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
            
        } else if NavLayer.IsAccesory(substance.state.layerActive){
//            let index = NavLayer.AccesoryIndex(substance.state.layerActive)
            //TODO: handle this
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
    
    func navigateToController(layer:String,fluxLock:FluxLock){
        
      
        assert(substance.state.layers[layer] != nil, "layer is not defined!")
        
        let stringContext = substance.state.layers[layer]! as! String
        var context = NavContext(fromString: stringContext)
        
        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: context.controller)
        
        print("--> navigateTo \(context.path())")
        guard context.controller != ROOT_CONTROLLER else{
            navigateToRootView(navOperation: navOperation)
            return
        }
        
        let controller = controllerFrom(context: context, navOperation:navOperation)
        context.viewController = controller
        
        startOperationFor(controller: controller, navOperation: navOperation) {[weak self] (operation) in
            
            self?.contextInitIntent(controller: controller, context: context)
            self?.setupEmptyStateIntent(controller: controller, context: context)
            if(context.intention == .Push){
                self?.pushController(controller, context: context)
            }else{
                self?.popToController(controller, context: context)
            }
    
            self?.setupContentIntent(controller: controller, context: context, navOperation: navOperation)
            
        }
        
        
    }
}
