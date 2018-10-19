//
//  Nav+Display.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    
    public func displayTabOperation(_ index:Int, completion:@escaping (Bool)->Void){
        DispatchQueue.main.async {
            print("Display tabIndex: \(index)")
            self.tabController?.selectedIndex = index
        }
        dismissModalOperation {
            DispatchQueue.main.async {  [weak self] in
                self?.presentTab(index: index, completion: completion)
            }
        }
        
    }
    public func displayNavOperation(completion:@escaping (Bool)->Void){
        dismissModalOperation {
            DispatchQueue.main.async { [weak self] in
                self?.dismissTab(completion: completion)
            }
        }
    }
    public func displayModalOperation(completion:@escaping ()->Void){
        DispatchQueue.main.async {  [weak self] in
            if (self?._isModalPresented())! == true {
                completion()
                return
            }
            
            self?.presentModal(completion: completion)
        }
    }
    
    public func dismissModalOperation(completion:@escaping ()->Void){
        DispatchQueue.main.async {  [weak self] in
            if (self?._isModalPresented())! == false {
                completion()
                return
            }
            
            self?.dismissModal(completion: completion)
        }
    }
    
}
extension FlaskNav{
    
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
            
            execute()
            
            if NavLayer.IsModal(context.layer) &&  self._isModalPresented() == false {
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



