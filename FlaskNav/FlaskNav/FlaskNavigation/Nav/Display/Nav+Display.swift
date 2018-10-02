//
//  Nav+Display.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    public func displayNav(){
        
        DispatchQueue.main.async { [weak self] in
            self?.dismissViewController(animated: false, completion: {})
        }
    }
    
    public func displayTab(_ index:Int){
        DispatchQueue.main.async {  [weak self] in
            self?.present((self?.tabController!)!, animated: false, completion:{})
        }
    }
}

extension FlaskNav{
    
    func popToRoot(context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let nav = (self?.navInstance(forLayer: context.layer))!
            let animated = context.animation != .None
            nav.popToRootViewController(animated:animated)
        }
    }
    
    func pushController(_ controller:UIViewController, context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let nav = (self?.navInstance(forLayer: context.layer))!
            let animated = context.animation != .None
            nav.pushViewController(controller, animated: animated)
            
        }
    }
    
    func popToController(_ controller:UIViewController, context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let nav = (self?.navInstance(forLayer: context.layer))!
            let animated = context.animation != .None
            nav.popToViewController(controller, animated: animated)
        }
    }
    
}

extension FlaskNav {
    
    
    func presentAccessory(_ controller:UIViewController,  context:NavContext){
        
    }
    
    
}

