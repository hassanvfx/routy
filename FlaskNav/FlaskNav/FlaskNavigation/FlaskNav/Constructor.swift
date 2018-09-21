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
        let instance = constructor(context)
        
        
        
        cachedControllers[key] = NavWeakRef(value:instance)
        
        return (controller:instance, cached:false)
        
    }
    
    func asyncSetupIntent(controller:UIViewController, context:NavigationContext, navOperation:FlaskNavOperation){
        
        if let instanceAsyncSetup = controller as? FlaskNavAsyncSetup {
            
            navOperation.lockNavigation()
            let completion = {
                navOperation.releaseNavigation()
            }
            DispatchQueue.main.async {
                instanceAsyncSetup.setupWith(navigationContext: context, setupCompleted: completion)
            }
        }
    }
    
}
