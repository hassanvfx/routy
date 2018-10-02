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
        
        if let stack = stackLayers[name] {
            return stack
        }
        let newStack = NavStack(layer:name)
        stackLayers[name] = newStack
        return newStack
    }
}


extension FlaskNav: NavStackAPI{
    
    func push(layer:String, batched:Bool = false, controller:String , resourceId:String?, info:Any? = nil, callback:NavContextCallback? = nil){
        queueIntent(batched:batched) { [weak self] in
            let context = NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, callback)
            self?.stackActive = layer
            self?.stack(forLayer: layer).push(context: context)
        }
    }
    
    func pop(layer:String, batched:Bool = false, toController controller:String, resourceId:String?, info:Any?){
        queueIntent(batched:batched) { [weak self] in
            let context =  NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info)
            self?.stackActive = layer
            self?.stack(forLayer: layer).pop(toContextRef: context)
        }
    }
    func popCurrent(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            self?.stackActive = layer
            self?.stack(forLayer: layer).pop()
        }
    }
    func popToRoot(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            self?.stackActive = layer
            self?.stack(forLayer: layer).clear()
        }
    }
    
    func show(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            //TODO: handle show nav or nav
            self?.stackActive = layer
        }
    }
    
    
}






