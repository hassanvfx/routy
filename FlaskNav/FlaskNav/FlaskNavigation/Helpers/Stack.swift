//
//  Stack.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class NavStack {
    
    public private(set) var stack:[NavigationContext] = []
    public private(set) var locked = false
    
    public static let stackQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    public func rootContext()->NavigationContext{
        return NavigationContext( controller: ROOT_CONTROLLER, resourceId: nil, payload: nil)
    }
    
    public func clear(){
        stack = []
    }
    
    public func push(context:NavigationContext){
        stack.append(context)
    }
    
    
    public func pop(){
        _ = stack.dropLast()
    }
    
    public func current() -> NavigationContext{
        if stack.isEmpty {
            return rootContext()
        }
        return stack.last!
    }
    
    public func pop(toContext aContext:NavigationContext){
        
        
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

extension NavStack {
    
    public func lock(){
        locked = true
    }
    
    public func unlock(){
        locked = false
    }
    
    public func enqueue(_ closure:@escaping ()->Void){
        NavStack.stackQueue.addOperation { 
            closure()
        }
    }
}
