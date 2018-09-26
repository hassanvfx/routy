//
//  Stack.swift
//  Roots
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class NavStack {
    
    public private(set) var stack:[NavContext] = []
    static public private(set) var locked = false
    
    public static let stackQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    public func rootContext()->NavContext{
        return NavContext( controller: ROOT_CONTROLLER, resourceId: nil, info: nil)
    }
    
    public func clear(){
        stack = []
    }
    
    public func push(context:NavContext){
        stack.append(context)
    }
    
    
    public func pop(){
        _ = stack.removeLast()
    }
    
    public func current() -> NavContext{
        if stack.isEmpty {
            return rootContext()
        }
        return stack.last!
    }
    
    public func pop(toContext aContext:NavContext){
        
        
        let aStack = stack
        var result:NavContext? = nil
        while (result == nil && aStack.count > 0) {
            
            let lastContext = aStack.last
            
            if(lastContext?.controller == aContext.controller &&
                lastContext?.resourceId == aContext.resourceId){
                
                if(aContext._payload == nil ||
                    aContext._payload == lastContext?._payload){
                    result = aContext
                }
            }
            _=stack.removeLast()
        }
        
        stack = aStack
        
    }

}

extension NavStack {
    
    static public func lock(){
        locked = true
    }
    
    static public func unlock(){
        locked = false
    }
    
    static public func enqueue(_ closure:@escaping ()->Void){
        NavStack.stackQueue.addOperation { 
            closure()
        }
    }
}
