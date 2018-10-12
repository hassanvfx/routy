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
    
    static public private(set) var locked = false
    public static let stackQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    public var currentNavigator:NavigatorType = .Root
    
    public private(set) var stack:[NavContext] = []
    var capturedStack:[NavContext]? = nil
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
    
    public func clear(withAnimator animator:NavAnimatorClass? = nil){
        currentNavigator = .Root
        rootContext.animator = animator
        stack = []
    }
    
    public func push(context:NavContext){
        currentNavigator = .Push
        stack.append(context)
    }
    
    public func pop(withAnimator animator:NavAnimatorClass?){
        if (stack.count <= 1 ){clear(withAnimator: animator); return}
        
        currentNavigator = .Pop
        _ = stack.removeLast()
        
        stack.last?.animator = animator
    }

    public func pop(toContextRef refContext:NavContext){
        currentNavigator = .Pop
        
        var aStack = stack
        var result:NavContext? = nil
        while (result == nil && aStack.count > 0) {
            
            guard
                let lastContext = aStack.last
            else{
                continue
            }
            
            if(lastContext.controller == refContext.controller &&
                lastContext.resourceId == refContext.resourceId){
                
                result = lastContext
                result?.animator = refContext.animator
            }
            
            _ = aStack.removeLast()
        }
        
        stack = aStack
        
        if (stack.isEmpty){
            push(context: refContext)
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


extension NavStack {
    
    public func capture(){
        assert(capturedStack == nil, "stack already captured")
        capturedStack = stack
        for context in capturedStack! {
            context.captureState()
        }
    }
    
    public func rollback(){
        assert(capturedStack != nil, "stack not captured")
        for context in capturedStack! {
            context.rollbackState()
        }
        stack = capturedStack!
        capturedStack = nil
    }
    
    public func commit(){
        assert(capturedStack != nil, "stack not captured")
        for context in capturedStack! {
            context.commitState()
        }
        capturedStack = nil
    }
    
}
