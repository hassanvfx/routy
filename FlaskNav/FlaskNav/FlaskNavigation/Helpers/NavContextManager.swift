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
    
    var contexts:[Int:NavContext] = [:]
    
    static let shared = NavContextManager()
    var contextCounter = 0
    var locked = false
    
}
extension NavContextManager{
   
    public func context( controller:String, resourceId:String?,  info:Any?, animation:NavigationAnimations = .Default, _ callback:NavContextCallback? = nil) -> NavContext{
        
        let contextId = self.nextId()
        let context = NavContext(id: contextId, controller: controller, resourceId: resourceId, info: info, animation: animation, callback)
        register(context: context)
        
        return context
    }
    
    
    func context(fromContextId contextId:Int)->NavContext{
        return contexts[contextId]!
    }
    
    func context(fromViewController viewController:UIViewController)->NavContext?{
        let filtered = contexts.filter{ $0.value.viewController() == viewController}
        assert(filtered.count <= 1,"there should be only one match")
        return filtered.first?.value
    }
    
    
    func register(context:NavContext){
        contexts[context.contextId] = context
    }
    
    public func releaseOnPop(context:NavContext){
        if(context.navigator != .Pop){ return }
        
        context.setWeakViewController(true)
        contexts[context.contextId] = nil
    }

}

extension NavContextManager{
    
    func context(fromStateHash hash:String)->NavContext{
        
        do{
            let jsonData = hash.data(using: .utf8)!
            let info = try JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            let contextId = info["contextId"] as! String
            return context(fromContextId: Int(contextId)!)
        }catch{
            fatalError("serialization error")
        }
    }
    
    func navigator(fromStateHash hash:String)->NavigatorType{
        do{
            let jsonData = hash.data(using: .utf8)!
            let info = try JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            let navigator = info["navigator"] as! String
            return NavigatorType(rawValue: navigator)!
        }catch{
            fatalError("serialization error")
        }
    }
    
    func stateHash(from context:NavContext, navigator:NavigatorType)->String{
        
        let info = [
            "controller":context.controller,
            "resourceId":context.resourceId,
            "contextId":String(context.contextId),
            "navigator":navigator.rawValue
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: info, options: [])
            return String(data: jsonData, encoding: .utf8)!
        }catch{
            fatalError("Serialization error")
        }
    }
}

extension NavContextManager{
    func nextId()->Int{
        assert(!locked, "this method is not thread safe!")
        locked = true
        defer {
            locked = false
        }
        
        contextCounter+=1
        return contextCounter
    }
}
