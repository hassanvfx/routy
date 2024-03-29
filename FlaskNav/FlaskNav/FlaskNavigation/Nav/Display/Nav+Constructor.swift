//
//  Factory.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav{
    
    func controllerConstructor(for controller:String)->NavConstructor{
        if let constructor = controllers[controller]{
            return constructor
        }
        if let constructor = modals[controller]{
            return constructor
        }
        fatalError("constuctor for `\(controller)` not defined")
    }
    
    func controllerFrom(context:NavContext, navOperation:FlaskNavOperation)->UIViewController{
        
        if context.controller == ROOT_CONTROLLER {
            return activeRootController(for:context.layer)!
        }
        
        let constructor = controllerConstructor(for: context.controller)
        let instance = constructor()
        
        return instance
        
    }
    
    func contextInitIntent(controller:UIViewController, context:NavContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetup {
            
            let nav = navInstance(forLayer: context.layer)
            
            if let info = context.info as? NavInfo {
                info.context = context
                info.onWillInit?(nav, context)
                info.onWillInit = nil
            }
            
            instanceAsyncSetup.navContextInit(withContext: context)
            
            if let info = context.info as? NavInfo {
                info.onDidInit?(nav, context)
                info.onDidInit = nil
            }
        }
    }
    
    func setupEmptyStateIntent(controller:UIViewController, context:NavContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetup {
            
            let nav = navInstance(forLayer: context.layer)
            
            DispatchQueue.main.async {
                
                if let info = context.info as? NavInfo {
                    info.onWillSetupEmptyState?(nav, context)
                    info.onWillSetupEmptyState = nil
                }
                
                instanceAsyncSetup.setupEmptyState()
                
                if let info = context.info as? NavInfo {
                    info.onDidSetupEmptyState?(nav, context)
                    info.onDidSetupEmptyState = nil
                }
            }
        }
        
    }
    
    
    func setupContentIntent(controller:UIViewController, context:NavContext, navOperation:FlaskNavOperation){
        
        guard let instanceAsyncSetup = controller as? FlaskNavSetup else { return }
        
        let nav = navInstance(forLayer: context.layer)
        
        let completion = { [weak self] (contentOperation:FlaskOperation) in
            
            navOperation.releaseNavigation()
            self?.waitingForContentCompletion = false
            
        }
        
        let operation = FlaskOperation(){ [weak self] operation in
            
            assert(self?.waitingForContentCompletion == false, "Ensure to call the `setupContent(...` `completionHandler()`" )
            self?.waitingForContentCompletion = true
            
            navOperation.lockNavigation()
            
            DispatchQueue.main.async {
                
                if let info = context.info as? NavInfo {
                    info.onWillSetupContent?(nav, context)
                    info.onWillSetupContent = nil
                }
                
                let finalizer = {
                    completion(operation)
                }
                
                instanceAsyncSetup.setupContent(with: finalizer )
                
                if let info = context.info as? NavInfo {
                    info.onDidSetupContent?(nav, context)
                    info.onDidSetupContent = nil
                    info.onDidSetup?(nav, context)
                    info.onDidSetup = nil
                }
            }
        }
        
        self.contentQueue.addOperation(operation)
    }
    
}
