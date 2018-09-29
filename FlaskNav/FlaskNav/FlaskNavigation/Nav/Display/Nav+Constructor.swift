//
//  Factory.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    func controllerConstructor(for controller:String)->ControllerConstructor{
        if let constructor = _controllers[controller]{
            return constructor
        }
        fatalError("constuctor for `\(controller)` not defined")
    }
    
    func cachedControllerFrom(context:NavContext, navOperation:FlaskNavOperation)->(controller:UIViewController,cached:Bool){
        
        let key = context.toString()
        if let value = cachedControllers[key]?.value{
            if (navController?.viewControllers.contains(value))!{
                return (controller:value, cached:true)
            }else{
                cachedControllers[key] = nil
            }
        }
        
        let constructor = controllerConstructor(for: context.controller)
        let instance = constructor()

        cachedControllers[key] = NavWeakRef(value:instance)
        
        return (controller:instance, cached:false)
        
    }
    
    func controllerFrom(context:NavContext, navOperation:FlaskNavOperation)->UIViewController{
        
        let key = context.toString()

        let constructor = controllerConstructor(for: context.controller)
        let instance = constructor()
        
        cachedControllers[key] = NavWeakRef(value:instance)
        
        return instance
        
    }
    
    func contextInitIntent(controller:UIViewController, context:NavContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetup {
            instanceAsyncSetup.navContextInit(withContext: context)
        }
    }
    
    func setupEmptyStateIntent(controller:UIViewController, context:NavContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetup {
            
            DispatchQueue.main.async {
                instanceAsyncSetup.setupEmptyState()
            }
        }
    }
    
    
    func setupContentIntent(controller:UIViewController, context:NavContext, navOperation:FlaskNavOperation){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetup {
            
            let completion = { [weak self] in
                _ = self?.contentQueue.addOperation {
                    self?.waitingForContentCompletion = false
                    navOperation.releaseNavigation()
                }
            }
            
            self.contentQueue.addOperation { [weak self] in
                
                assert(self?.waitingForContentCompletion == false, "Ensure to call the `setupContent(...` `completionHandler()`" )
                self?.waitingForContentCompletion = true
               
                navOperation.lockNavigation()
                DispatchQueue.main.async { 
                    instanceAsyncSetup.setupContent(with: completion )
                }
            }
        }
    }
    
}
