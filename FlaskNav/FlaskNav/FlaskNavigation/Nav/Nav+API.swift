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
    
    public func push(controller:T, resourceId:String? = nil, info:CodableInfo? = nil){
        push(controller:controller.rawValue as! String , resourceId:resourceId, info:info)
    }
    
    public func pop(controller:T, resourceId:String? = nil, info:CodableInfo? = nil){
        pop(toController:controller.rawValue as! String , resourceId:resourceId, info:info)
    }
}

extension FlaskNav: NavAPIDelegate{
    
    func push(controller:String , resourceId:String?, info:CodableInfo? = nil, batched:Bool = false){
        batch(on:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack.push(context: context)
        }
    }
    
    func pop(toController controller:String, resourceId:String?, info:CodableInfo?, batched:Bool = false){
        batch(on:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack.pop(toContext: context)
        }
    }
    func popCurrentControler(batched:Bool = false){
        batch(on:batched) { [weak self] in
            self?.stack.pop()
        }
    }
    func popToRootController(batched:Bool = false){
        batch(on:batched) { [weak self] in
            self?.stack.clear()
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
    
    
    func transaction(_ closure:@escaping (NavBatch<T>)->Void){
        
        stack.enqueue { [weak self] in
            assert(self?.stack.locked == false, "error the `stack` is currently locked")
            
            let batch = NavBatch<T>(delegate: self)
            self?.stack.lock()
            closure(batch)
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
        //        let context = NavContext(controller: stringAccesory, resourceId: nil, payload: payload)
        //
        //        Flask.lock(withMixer: NavMixers.Accesory, payload: ["context":context.toString()])
        
    }
}

