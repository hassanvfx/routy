//
//  Nav+Config.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


extension FlaskNav{
    func _configControllers(){
        viewControllers = [:]
        defineControllers()
        
        assert(viewControllers.count > 0, "Ensure to define your controllers using `controllers` example `controllers[.Name] = { (payload) in UIViewController() }`")
        
        mapControllers()
    }
    
    func _configModals(){
        
        defineModals()
    }
    
    func mapControllers(){
        _controllers = [:]
        
        for (key,value) in viewControllers {
            let stringKey = key.rawValue as! String
            _controllers[stringKey] = value
        }
    }
}

extension FlaskNav{
    
    
    public func defineNavRoot(_ constructor:@escaping ControllerConstructor){
        navRoot = constructor
    }
    public func defineTabRoot(_ tab:TABS, _ constructor:@escaping ControllerConstructor){
        let stringKey = tab.rawValue as! String
        tabs[stringKey] = constructor
    }
    public func define(controller:CONT,_ constructor:@escaping ControllerConstructor){
        let stringKey = controller.rawValue as! String
        _controllers[stringKey] = constructor
    }
    public func define(modal:MODS,_ constructor:@escaping ControllerConstructor){
        let stringKey = modal.rawValue as! String
        modals[stringKey] = constructor
    }
}

