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
    
    func contextInitIntent(controller:UIViewController, context:NavigationContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetupAsync {
            instanceAsyncSetup.navContextInit(withContext: context)
        }
    }
    
    func navInitIntent(controller:UIViewController, context:NavigationContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetupAsync {
            
            DispatchQueue.main.async {
                instanceAsyncSetup.setupEmptyState()
            }
        }
    }
    
    func syncSetupIntent(controller:UIViewController, context:NavigationContext){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetup {
            
            DispatchQueue.main.async {
                instanceAsyncSetup.setupContent()
            }
        }
    }
    
    func asyncSetupIntent(controller:UIViewController, context:NavigationContext, navOperation:FlaskNavOperation){
        
        if let instanceAsyncSetup = controller as? FlaskNavSetupAsync {
            
            navOperation.lockNavigation()
            let completion = {
                navOperation.releaseNavigation()
            }
            DispatchQueue.main.async {
                instanceAsyncSetup.setupContent(with: completion)
            }
        }
    }
    
}
