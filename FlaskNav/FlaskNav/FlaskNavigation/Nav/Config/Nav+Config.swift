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
    
    func _configAccesories(){
        
        defineAccesories()
    }
    
    func mapControllers(){
        _controllers = [:]
        
        for (key,value) in viewControllers {
            let stringKey = key.rawValue as! String
            _controllers[stringKey] = value
        }
    }
}

