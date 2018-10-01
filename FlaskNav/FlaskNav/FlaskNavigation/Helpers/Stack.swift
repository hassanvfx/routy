//
//  Stack.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class NavStack {
    
    public private(set) var stack:[NavContext] = []
    static public private(set) var locked = false
    public var currentNavigator:NavigatorType = .Root
    
    static let rootContext = NavContext.manager.context(controller: ROOT_CONTROLLER, resourceId: nil, info: nil)
    public static let stackQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    
    public func currentContextHash()->String{
        let context = currentContext()
        return NavContext.manager.stateHash(from:context,navigator:currentNavigator)
    }
    
    public func currentContext() -> NavContext{
        if stack.isEmpty {
            return NavStack.rootContext
        }
        return stack.last!
    }
    
    public func clear(){
        currentNavigator = .Root
        stack = []
    }
    
    public func push(context:NavContext){
        currentNavigator = .Push
        stack.append(context)
    }
    
    public func pop(){
        if (stack.count <= 1 ){clear(); return}
        
        currentNavigator = .Pop
        _ = stack.removeLast()
    }

    public func pop(toContext aContext:NavContext){
        currentNavigator = .Pop
        
        var aStack = stack
        var result:NavContext? = nil
        while (result == nil && aStack.count > 0) {
            
            let lastContext = aStack.last
            
            if(lastContext?.controller == aContext.controller &&
                lastContext?.resourceId == aContext.resourceId){
                
                result = aContext
            }
            
            _ = aStack.removeLast()
        }
        
        stack = aStack
        
        if (stack.isEmpty){
            push(context: aContext)
        }
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
