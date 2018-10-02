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
        if let constructor = controllers[controller]{
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
