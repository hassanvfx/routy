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
    
    func isValidComposition(nav:FlaskNavigationController, context:NavContext)->Bool{
        
        print("validating composition... \(context.desc()) modal:\(isModalPresented()) tab:\(isTabPresented())")
        
        if context.navigator == .Root &&  nav.viewControllers.count == 1{
            print("error: already root \(context.desc())")
            return false
        }else if context.navigator == .Pop && context.viewController() == nil{
            print("error: no controller to pop \(context.desc())")
            return false
        }else if context.navigator == .Pop && context.viewController() != nil && !(nav.viewControllers.contains(context.viewController()!)){
            print("error: controller not in nav \(context.desc())")
            return false
        }else if NavLayer.IsModal(context.layer) &&  !isModalPresented() {
            print("error: modal not visible \(context.desc())")
            return false
        }else if NavLayer.IsTab(context.layer) &&  !isTabPresented() {
            print("error: tab not visible \(context.desc())")
            return false
        }else if NavLayer.IsNav(context.layer) && (isModalPresented() || isTabPresented()) {
            print("error: nav not top controller \(context.desc())")
            return false
        }
        
        return true
    }
    
   
    func dismissModalIntent(with context:NavContext, action:@escaping ()->Void){
        
        if NavLayer.IsModal(context.layer){
            print("skip HIDE modal -> context IS modal")
            action()
            return
        }
        
        
        print("may HIDE modal...")
        dismissModal() {
            print("after HIDE modal intent")
            action()
        }
    }
    
    func ensureNavCompletion(with context:NavContext, _ action:@escaping ()->Void){
        
        let nav = navInstance(forLayer: context.layer)
        let animatorDuration = context.animator?._duration ?? 1.0
        let delay = max( animatorDuration, 4.0) * 1.2
        
        
        let abort = { [weak self] in
            print("Aborting NAV Operation!! \(context.desc())")
            self?.intentToCompleteOperationFor(context: context, completed: false)
        }
        
        
        let execute = { [weak self] in
            
            print("Performing NAV Operation! \(context.desc())")
            action()
            self?.watchForNavOperationToComplete(delay: delay){
               abort()
            }
        }
        
        let prepareAndExecute = { [weak self] in
            
            print("Preparing NAV Operation \(context.desc())")
            
            nav._isPerformingNavOperation = true
            self?.dismissModalIntent(with: context){
                execute()
            }
        }

        if isValidComposition(nav: nav, context: context){
            prepareAndExecute()
        }else{
            print("Invalid NAV composition! \(context.desc())")
            abort()
            return
        }
    }
    
    
}

extension FlaskNav{
    
    func navOperationKey()->String{
        return "navOperationWatchdog"
    }
    
    func cancelWatchForNavOperationToComplete(){
        
//        print("cancelling WATCHDOG")
//        Kron.watchDogCancel(key:navOperationKey())
    }
    
    func watchForNavOperationToComplete(delay: Double, retry:@escaping ()->Void){
        
//        print("setting WATCHDOG")
//        Kron.watchDog(timeOut: delay, resetKey: navOperationKey()){ key,ctx  in
//            retry()
//        }
    }
}
