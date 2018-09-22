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
    
    func cachedControllerFrom(context:NavigationContext, navOperation:FlaskNavOperation)->(controller:UIViewController,cached:Bool){
        
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
    
    func controllerFrom(context:NavigationContext, navOperation:FlaskNavOperation)->UIViewController{
        
        let key = context.toString()

        let constructor = controllerConstructor(for: context.controller)
        let instance = constructor()
        
        cachedControllers[key] = NavWeakRef(value:instance)
        
        return instance
        
    }
    
    func asyncInitIntent(controller:UIViewController, context:NavigationContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavAsyncSetup {
            
            DispatchQueue.main.async {
                instanceAsyncSetup.asyncInit(withContext: context)
            }
        }
    }
    
    func asyncSetupIntent(controller:UIViewController, context:NavigationContext, navOperation:FlaskNavOperation){
        
        if let instanceAsyncSetup = controller as? FlaskNavAsyncSetup {
            
            navOperation.lockNavigation()
            let completion = {
                navOperation.releaseNavigation()
            }
            DispatchQueue.main.async {
                instanceAsyncSetup.asyncSetup(withContext: context, setupFinalizer: completion)
            }
        }
    }
    
}
