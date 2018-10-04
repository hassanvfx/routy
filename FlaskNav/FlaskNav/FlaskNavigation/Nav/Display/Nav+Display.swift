//
//  Nav+Display.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{

    
    public func displayTabOperation(_ index:Int, completion:@escaping ()->Void){
        DispatchQueue.main.async {
            self.tabController?.selectedIndex = index
        }
        dismissModalOperation {
            DispatchQueue.main.async {  [weak self] in
                self?.presentTab(index: index, completion: completion)
            }
        }
        
    }
    public func displayNavOperation(completion:@escaping ()->Void){
        dismissModalOperation {
            DispatchQueue.main.async { [weak self] in
                self?.dismissTab(completion: completion)
            }
        }
    }
    public func displayModalOperation(completion:@escaping ()->Void){
        DispatchQueue.main.async {  [weak self] in
            if (self?.isModalPresented())! == true {
                completion()
                return
            }
            
            self?.presentModal(completion: completion)
        }
    }
    
    public func dismissModalOperation(completion:@escaping ()->Void){
        DispatchQueue.main.async {  [weak self] in
            if (self?.isModalPresented())! == false {
                completion()
                return
            }
            
            self?.dismissModal(completion: completion)
        }
    }
    
}

extension FlaskNav{
    
    func popToRoot(context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let nav = (self?.navInstance(forLayer: context.layer))!
            nav.popToRootViewController(animated:true)
        }
    }
    
    func pushController(_ controller:UIViewController, context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let nav = (self?.navInstance(forLayer: context.layer))!
            nav.pushViewController(controller, animated: true)
            
        }
    }
    
    func popToController(_ controller:UIViewController, context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let nav = (self?.navInstance(forLayer: context.layer))!
            nav.popToViewController(controller, animated: true)
        }
    }
    
}

extension FlaskNav {
    
    
    func presentAccessory(_ controller:UIViewController,  context:NavContext){
        
    }
    
    
}

