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
 
    func stack(forLayer name:String)->NavStack{
        if let stack = layers[name] {
            return stack
        }
        let newStack = NavStack()
        layers[name] = newStack
        return NavStack()
    }
}


extension FlaskNav: StackDelegate{
    
    func push(layer:String, controller:String , resourceId:String?, info:CodableInfo? = nil, batched:Bool = false){
        navigate(batched:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack(forLayer: layer).push(context: context)
        }
    }
    
    func pop(layer:String, toController controller:String, resourceId:String?, info:CodableInfo?, batched:Bool = false){
        navigate(batched:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack(forLayer: layer).pop(toContext: context)
        }
    }
    func popCurrentControler(layer:String, batched:Bool = false){
        navigate(batched:batched) { [weak self] in
            self?.stack(forLayer: layer).pop()
        }
    }
    func popToRootController(layer:String, batched:Bool = false){
        navigate(batched:batched) { [weak self] in
            self?.stack(forLayer: layer).clear()
        }
    }
    
    
}


extension FlaskNav{
    
    public func navigate(batched:Bool,action:@escaping ()->Void){
        if batched {
            action()
        } else{
            enqueueNow(action)
        }
    }
    
    func enqueueNow(_ closure:@escaping ()->Void){
        
        NavStack.enqueue { [weak self] in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            closure()
            NavStack.unlock()
            self?.applyContext()
        }
    }
    
    
    func transaction(_ closure:@escaping (NavComposition<TABS,CONT,ACCS>)->Void){
        
        NavStack.enqueue { [weak self] in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
   
            NavStack.lock()
            if let my = self {
                closure(my.compositionBatch!)
            }
            NavStack.unlock()
            self?.applyContext()
        }
        
    }
    
    func applyContext(){
        let context = self.stack(forLayer: StackLayer.Main()).current()
        Flask.lock(withMixer: NavMixers.Controller, payload: ["context":context.toString()])
    }
    
}



