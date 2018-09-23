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
    
    public func push(onBatch:Bool=false, controller:T, payload:CodablePayload? = nil){
        push(onBatch:onBatch, controller:controller,resourceId:nil,payload:payload)
    }
    
    public func push(onBatch useBatch:Bool=false, controller:T, resourceId:String?, payload:CodablePayload? = nil){
        
        batch(on:useBatch) { [weak self] in
            let stringController = controller.rawValue as! String
            let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
            self?.stack.push(context: context)
        }
        
    }
    
    
}

extension FlaskNav{
    
    public func pop(onBatch useBatch:Bool=false, toController controller:T, payload:CodablePayload? = nil){
        pop(toController: controller,resourceId:nil, payload:payload)
    }
    
    public func pop(onBatch useBatch:Bool=false, toController controller:T, resourceId:String?, payload:CodablePayload? = nil){
        
        batch(on:useBatch) { [weak self] in
            let stringController = controller.rawValue as! String
            let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
            self?.stack.pop(toContext: context)
        }
    }
    
    public func popCurrentControler(onBatch useBatch:Bool=false){
        batch(on:useBatch) { [weak self] in
            self?.stack.pop()
        }
    }
}

extension FlaskNav{
    
    public func batch(on onBatch:Bool,action:@escaping ()->Void){
        if onBatch {
            action()
        } else{
            batch(action)
        }
    }
    func batch(_ closure:@escaping ()->Void){
        
        stack.enqueue { [weak self] in
            assert(self?.stack.locked == false, "error the `stack` is currently locked")
            
            self?.stack.lock()
            closure()
            self?.stack.unlock()
            self?.applyContext()
        }
        
        
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
