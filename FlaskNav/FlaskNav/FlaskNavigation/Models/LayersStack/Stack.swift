//
//  Stack.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

public class NavStack {
    
    public static let stackQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    public private(set) var stack:[NavContext] = []
    static public private(set) var locked = false
    public var currentNavigator:NavigatorType = .Root
    
    let rootContext:NavContext
    let layer:String
    
    init(layer:String){
        self.layer = layer
        self.rootContext = NavContext.manager.contextRoot(forLayer: layer)!
    }
    
   
    
    
    public func currentContextHash()->String{
        let context = currentContext()
        return NavContext.manager.stateHash(from:context,navigator:currentNavigator)
    }
    
    public func currentContext() -> NavContext{
        if stack.isEmpty {
            return rootContext
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

    public func pop(toContextRef aContext:NavContext){
        currentNavigator = .Pop
        
        var aStack = stack
        var result:NavContext? = nil
        while (result == nil && aStack.count > 0) {
            
            guard
                let lastContext = aStack.last
            else{
                continue
            }
            
            if(lastContext.controller == aContext.controller &&
                lastContext.resourceId == aContext.resourceId){
                
                result = lastContext
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
    
    static public func enqueue(operation:FlaskOperation){
        NavStack.stackQueue.addOperation(operation)
    }
}
