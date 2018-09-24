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
    public func push(controller:T, info:CodableInfo? = nil){
        push(controller:controller.rawValue as! String , resourceId:nil, info:info)
    }
    
    public func push(controller:T, resourceId:String?, info:CodableInfo? = nil){
        push(controller:controller.rawValue as! String , resourceId:resourceId, info:info)
    }
}

extension FlaskNav: NavAPIDelegate{
    

    func push(controller:String , resourceId:String?, info:CodableInfo? = nil, batched:Bool = false){
        
        batch(on:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack.push(context: context)
        }
        
    }
    
    
}

extension FlaskNav{
    
    public func pop(onBatch useBatch:Bool=false, toController controller:T, info:CodableInfo? = nil){
        pop(toController: controller,resourceId:nil, info:info)
    }
    
    public func pop(onBatch useBatch:Bool=false, toController controller:T, resourceId:String?, info:CodableInfo? = nil){
        
        batch(on:useBatch) { [weak self] in
            let stringController = controller.rawValue as! String
            let context = NavContext( controller: stringController, resourceId: resourceId, info: info)
            self?.stack.pop(toContext: context)
        }
    }
    
    public func popCurrentControler(onBatch useBatch:Bool=false){
        batch(on:useBatch) { [weak self] in
            self?.stack.pop()
        }
    }
    public func popToRootController(onBatch useBatch:Bool=false){
        batch(on:useBatch) { [weak self] in
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

