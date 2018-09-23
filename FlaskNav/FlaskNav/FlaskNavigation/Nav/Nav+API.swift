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
        stack.clear()
        applyContextIntent()
    }
    
}

extension FlaskNav{
    
    public func push(controller:T, payload:CodablePayload? = nil){
        push(controller:controller,resourceId:nil,payload:payload)
    }
    
    public func push(controller:T, resourceId:String?, payload:CodablePayload? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
        stack.push(context: context)
        applyContextIntent()
    }
}

extension FlaskNav{
    
    public func popCurrentControler(){
        stack.pop()
        applyContextIntent()
    }
    
    public func pop(toController controller:T, payload:CodablePayload? = nil){
        pop(toController: controller,resourceId:nil, payload:payload)
    }
    
    public func pop(toController controller:T, resourceId:String?, payload:CodablePayload? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
        stack.pop(toContext: context)
        applyContextIntent()
    }
}

extension FlaskNav{
    
    func transaction(_ closure:@escaping ()->Void){

        assert(stack.locked == false, "error the `stack` is currently locked")
        
        stack.lock()
        closure()
        stack.unlock()
        applyContext()
        
    }
    
    func applyContextIntent(){
        if(stack.locked){
            return
        }
        applyContext()
    }
    
    func applyContext(){
        let context = self.stack.current()
        Flask.lock(withMixer: NavMixers.Controller, payload: ["context":context.toString()])
    }
    
}

extension FlaskNav{
    
    public func push(accesory:A, payload:AnyCodable? = nil){
//        let stringAccesory = accesory.rawValue as! String
//        let context = NavigationContext(controller: stringAccesory, resourceId: nil, payload: payload)
//
//        Flask.lock(withMixer: NavMixers.Accesory, payload: ["context":context.toString()])
        
    }
}
