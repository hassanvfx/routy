//
//  Nav+API.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension Roots{
 
    func stack(forLayer name:String)->NavStack{
        if let stack = stackLayers[name] {
            return stack
        }
        let newStack = NavStack()
        stackLayers[name] = newStack
        return newStack
    }
}


extension Roots: NavStackAPI{
    
    func push(layer:String, controller:String , resourceId:String?, info:CodableInfo? = nil, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack(forLayer: layer).push(context: context)
        }
    }
    
    func pop(layer:String, toController controller:String, resourceId:String?, info:CodableInfo?, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            let context = NavContext( controller: controller, resourceId: resourceId, info: info)
            self?.stack(forLayer: layer).pop(toContext: context)
        }
    }
    func popCurrentControler(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            self?.stack(forLayer: layer).pop()
        }
    }
    func popToRootController(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            self?.stack(forLayer: layer).clear()
        }
    }
    
    
}






