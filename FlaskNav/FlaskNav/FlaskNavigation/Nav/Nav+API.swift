//
//  Nav+API.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask


extension FlaskNav{
    public func popToRootController(){
        let context = NavigationContext( controller: ROOT_CONTROLLER, resourceId: nil, payload: nil)
        Flask.lock(withMixer: NavigationMixers.Controller, payload: ["context":context.toString()])
    }
}

extension FlaskNav{
    
    public func push(controller:T, payload:AnyCodable? = nil){
        push(controller:controller,resourceId:nil,payload:payload)
    }
    
    public func push(controller:T, resourceId:String?, payload:AnyCodable? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
        
        Flask.lock(withMixer: NavigationMixers.Controller, payload: ["context":context.toString()])
        
    }
}

extension FlaskNav{
    
    public func push(accesory:A, payload:AnyCodable? = nil){
        let stringAccesory = accesory.rawValue as! String
        let context = NavigationContext(controller: stringAccesory, resourceId: nil, payload: payload)
        
        Flask.lock(withMixer: NavigationMixers.Accesory, payload: ["context":context.toString()])
        
    }
}
