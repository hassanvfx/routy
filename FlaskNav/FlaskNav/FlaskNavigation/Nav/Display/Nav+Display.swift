//
//  Nav+Display.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{

    
    public func displayTab(_ index:Int){
        dismissModal()
        DispatchQueue.main.async {  [weak self] in
            self?.presentTab(index:index, completion:{})
        }
    }
    public func displayNav(){
        dismissModal()
        DispatchQueue.main.async { [weak self] in
            self?.dismissTab(completion: {})
        }
    }
    public func displayModal(){
        DispatchQueue.main.async {  [weak self] in
            if (self?.isModalPresented())! == true { return}
            
            self?.presentModal(completion:{})
        }
    }
    
    public func dismissModal(){
        DispatchQueue.main.async {  [weak self] in
            if (self?.isModalPresented())! == false { return}
            
            self?.dismissModal(completion: {})
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

