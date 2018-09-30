//
//  NavContextManager.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/29/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public typealias NavContextCallback = (Any?)->Void

public class NavContextRef<T> where T: AnyObject {
    
    private(set) weak var value: T?
    
    init(value: T?) {
        self.value = value
    }
}

class NavContextManager {
    
    var payloads:[Int:Any] = [:]
    var payloadRefs:[Int:NavContextRef<AnyObject>] = [:]
    var closures:[Int:NavContextCallback] = [:]
    
    static let shared = NavContextManager()
    var contextCounter = 0
    var locked = false
    
    func nextId()->Int{
        assert(!locked, "this method is not thread safe!")
        locked = true
        defer {
            locked = false
        }
        
        contextCounter+=1
        return contextCounter
    }
    
    
    //MARK: INFO
    func setInfo(contextId:Int,_ payload:Any?){
        if payload == nil {return}
        
        if type(of: payload!) is AnyClass {
            let object = payload! as AnyObject
            let ref = NavContextRef(value: object)
            payloadRefs[contextId] = ref
        } else {
            payloads[contextId] = payload!
        }
    }
    
    func info(forContextId contextId:Int)->Any?{
        let ref = payloadRefs[contextId]
        
        if let ref = ref {
            return ref.value
        }
        
        return payloads[contextId] ?? nil
    }
    
    //MARK: CLOSURE
    
    func setClosure(contextId:Int,_ closure:NavContextCallback?){
        if closure == nil {return}
        closures[contextId] = closure
    }
    
    func closure(forContextId contextId:Int)->NavContextCallback?{
        return closures[contextId] ?? nil
    }
}
