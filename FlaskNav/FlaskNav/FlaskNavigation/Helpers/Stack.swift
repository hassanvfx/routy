//
//  Stack.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavStack {
    var stack:[NavigationContext] = []

    func rootContext()->NavigationContext{
        return NavigationContext( controller: ROOT_CONTROLLER, resourceId: nil, payload: nil)
    }
    
    func clear(){
        stack = []
    }
    
    func push(context:NavigationContext){
        stack.append(context)
    }
    
    
    func pop(){
        _ = stack.dropLast()
    }
    
    func current() -> NavigationContext{
        if stack.isEmpty {
            return rootContext()
        }
        return stack.last!
    }
    
    func pop(toContext aContext:NavigationContext){
        
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
    
    
}
