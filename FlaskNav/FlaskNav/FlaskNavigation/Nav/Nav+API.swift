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
        stackClear()
        applyContext()
    }
    
    func rootContext()->NavigationContext{
         return NavigationContext( controller: ROOT_CONTROLLER, resourceId: nil, payload: nil)
    }
}

extension FlaskNav{
    
    public func push(controller:T, payload:CodablePayload? = nil){
        push(controller:controller,resourceId:nil,payload:payload)
    }
    
    public func push(controller:T, resourceId:String?, payload:CodablePayload? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
        stackPush(context: context)
        applyContext()
    }
}

extension FlaskNav{
    
    public func popCurrentControler(){
        stackPop()
        applyContext()
    }
    
    public func pop(toController controller:T, payload:CodablePayload? = nil){
        pop(toController: controller,resourceId:nil, payload:payload)
    }
    
    public func pop(toController controller:T, resourceId:String?, payload:CodablePayload? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
        stackPopTo(context: context)
        applyContext()
    }
}

extension FlaskNav{
    
    func stackClear(){
        stack = []
    }
    
    
    func stackPop(){
        _ = stack.dropLast()
    }
    
    
    func stackPopTo(context aContext:NavigationContext){
        
        let aStack = stack
        var result:NavigationContext? = nil
        while (result == nil && aStack.count > 0) {
            
            let lastContext = aStack.last
            
            if(lastContext?.controller == aContext.controller &&
                lastContext?.resourceId == aContext.resourceId){
                
                if(aContext._payload == nil ||
                    aContext._payload == lastContext?._payload){
                    result = aContext
                }
            }
            _=stack.dropLast()
        }
        
        stack = aStack
        
    }
    
    func stackPush(context:NavigationContext){
        stack.append(context)
    }
    
    func applyContext(){
        
        var context = stack.last
        if context == nil{
            context = rootContext()
        }
        print("applyContext \(String(describing: stack))")
        Flask.lock(withMixer: NavigationMixers.Controller, payload: ["context":context!.toString()])
        
    }
    
}

extension FlaskNav{
    
    public func push(accesory:A, payload:AnyCodable? = nil){
//        let stringAccesory = accesory.rawValue as! String
//        let context = NavigationContext(controller: stringAccesory, resourceId: nil, payload: payload)
//
//        Flask.lock(withMixer: NavigationMixers.Accesory, payload: ["context":context.toString()])
        
    }
}
