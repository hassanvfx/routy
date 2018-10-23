//
//  Nav+Display.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Delayed

extension FlaskNav{
    

    
    func displayTabOperation(_ index:Int, completion:@escaping (Bool)->Void){
        DispatchQueue.main.async {
            print("Display tabIndex: \(index)")
            self.tabController?.selectedIndex = index
        }
        
        DispatchQueue.main.async {
            self.presentTab(index: index, completion: completion)
        }
        
    }
    func dismissTabOperation(completion:@escaping (Bool)->Void){
        DispatchQueue.main.async {
            self.dismissTab(completion: completion)
        }
    }
    
    func displayModalOperation(completion:@escaping ()->Void){
        DispatchQueue.main.async {
            self.presentModal(completion: completion)
        }
    }
    
    func dismissModalOperation(completion:@escaping ()->Void){
        DispatchQueue.main.async {
            self.dismissModal(completion: completion)
        }
    }
    
}
extension FlaskNav{
    
    func popToRoot(context:NavContext){
        let nav = navInstance(forLayer: context.layer)
        
        print("may POP-TO-ROOT \(context.desc())")
        ensureNavCompletion(with: context){
            DispatchQueue.main.async {
                print("is POPING-TO-ROOT \(context.desc())")
                nav.popToRootViewController(animated:true)
            }
        }
    }
    
    func pushController(_ controller:UIViewController, context:NavContext){
        
        let nav = navInstance(forLayer: context.layer)
        
        print("may PUSH \(context.desc())")
        
        ensureNavCompletion(with: context){
            DispatchQueue.main.async {
                print("is PUSHING now \(context.desc())")
                nav.pushViewController(controller, animated: true)
                
            }
        }
    }
    
    func popToController(_ controller:UIViewController, context:NavContext){
        let nav = navInstance(forLayer: context.layer)
        
        print("may POP \(context.desc())")
        
        ensureNavCompletion(with: context){
            DispatchQueue.main.async {
                print("is POPING \(context.desc())")
                nav.popToViewController(controller, animated: true)
            }
        }
        
    }
    
}


extension FlaskNav{
    
    func assertComposition(context:NavContext){
        
        if NavLayer.IsModal(context.layer) &&  !isModalPresented() && context.navigator != .Root {
             assert(false)
        }else if NavLayer.IsTab(context.layer) &&  !isTabPresented() {
             assert(false)
        } else if NavLayer.IsNav(context.layer) && (isModalPresented() || isTabPresented()) {
            print("nav may fail if layers are presented. modal:\(isModalPresented()) tab:\(isTabPresented())")
            assert(false)
        }
    }
    
   
    func dismissModalIntent(with context:NavContext, action:@escaping ()->Void){
        
        if NavLayer.IsModal(context.layer){
            action()
            return
        }
        
        dismissModal() {
            action()
        }
    }
    
    func ensureNavCompletion(with context:NavContext, _ action:@escaping ()->Void){
        
        let nav = navInstance(forLayer: context.layer)
        let animatorDuration = context.animator?._duration ?? 1.0
        let delay = max( animatorDuration, 4.0) * 1.2
        
        let retry = { [weak self] in
            print("Retrying NAV Operation!! \(context.desc())")
            action()
            self?.watchForNavOperationToComplete(delay: delay){
                print("Aborting NAV Operation!! \(context.desc())")
                self?.intentToCompleteOperationFor(context: context, completed: false)
            }
        }
        
        let execute = { [weak self] in
            print("Performing NAV Operation! \(context.desc())")
            action()
            self?.watchForNavOperationToComplete(delay: delay){
                retry()
            }
        }
        
        let prepareAndExecute = { [weak self] in
            
            self?.assertComposition(context: context)
            print("Preparing NAV Operation \(context.desc())")
            
            nav._isPerformingNavOperation = true
            self?.dismissModalIntent(with: context){
                execute()
            }
        }
        
        let complete = {
            print("Aborting NAV Operation!")
            DispatchQueue.main.async {
                self.intentToCompleteOperationFor(context: context)
            }
        }
        
        if context.navigator != .Root || (context.navigator == .Root && nav.viewControllers.count > 1){
            
            
            prepareAndExecute()
            
            if NavLayer.IsModal(context.layer) &&  self.isModalPresented() == false {
                complete()
            }
            if NavLayer.IsTab(context.layer) &&  self.isTabPresented() == false {
                complete()
            }
        } else{
            complete()
        }
    }
}

extension FlaskNav{
    
    func navOperationKey()->String{
        return "navOperationWatchdog"
    }
    
    func cancelWatchForNavOperationToComplete(){
        Kron.watchDogCancel(key:navOperationKey())
    }
    
    func watchForNavOperationToComplete(delay: Double, retry:@escaping ()->Void){
        Kron.watchDog(timeOut: delay, resetKey: navOperationKey()){ key,ctx  in
            retry()
        }
    }
}
