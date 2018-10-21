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
    
    
    public func displayTabOperation(_ index:Int, completion:@escaping (Bool)->Void){
        DispatchQueue.main.async {
            print("Display tabIndex: \(index)")
            self.tabController?.selectedIndex = index
        }
        presentTab(index: index, completion: completion)
        
    }
    public func displayNavOperation(completion:@escaping (Bool)->Void){
            dismissTab(completion: completion)
    }
    public func displayModalOperation(completion:@escaping ()->Void){
            presentModal(completion: completion)
    }
    
    public func dismissModalOperation(completion:@escaping ()->Void){
            dismissModal(completion: completion)
    }
    
}
extension FlaskNav{
    
    func popToRoot(context:NavContext){
        let nav = navInstance(forLayer: context.layer)
        
        print("may POP-TO-ROOT \(context.desc())")
        ensureNavCompletion(withContext: context){
            DispatchQueue.main.async {
                print("is POPING-TO-ROOT \(context.desc())")
                nav.popToRootViewController(animated:true)
            }
        }
    }
    
    func pushController(_ controller:UIViewController, context:NavContext){
        
        let nav = navInstance(forLayer: context.layer)
        
        print("may PUSH \(context.desc())")
        
        ensureNavCompletion(withContext: context){
            DispatchQueue.main.async {
                print("is PUSHING now \(context.desc())")
                nav.pushViewController(controller, animated: true)
                
            }
        }
    }
    
    func popToController(_ controller:UIViewController, context:NavContext){
        let nav = navInstance(forLayer: context.layer)
        
        print("may POP \(context.desc())")
        
        ensureNavCompletion(withContext: context){
            DispatchQueue.main.async {
                print("is POPING \(context.desc())")
                nav.popToViewController(controller, animated: true)
            }
        }
        
    }
    
}


extension FlaskNav{
    
    func assertComposition(context:NavContext){
        if NavLayer.IsModal(context.layer) &&  !self.isModalPresented()  {
             assert(false)
        }else if NavLayer.IsTab(context.layer) &&  !self.isTabPresented() {
             assert(false)
        } else if NavLayer.IsNav(context.layer) && (self.isModalPresented() || self.isTabPresented()) {
            assert(false,"nav may fail if layers are presented")
        }
    }
    
    func ensureNavCompletion(withContext context:NavContext, _ action:@escaping ()->Void){
        
        let nav = self.navInstance(forLayer: context.layer)
        
        let execute = {
            print("Executing NAV Operation!")
            nav._isPerformingNavOperation = true
            action()
        }
        
        let complete = {
            print("Aborting NAV Operation!")
            DispatchQueue.main.async {
                self.intentToCompleteOperationFor(context: context)
            }
        }
        
        if context.navigator != .Root || (context.navigator == .Root && nav.viewControllers.count > 1){
            
            assertComposition(context: context)
            
            execute()
            
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
    
    func watchForNavOperationToComplete(retry:@escaping (Int)->Void, retryCount:Int = 0){
        Kron.watchDog(timeOut: 2, resetKey: navOperationKey()){ key,ctx  in
            retry(retryCount + 1)
        }
    }
}
