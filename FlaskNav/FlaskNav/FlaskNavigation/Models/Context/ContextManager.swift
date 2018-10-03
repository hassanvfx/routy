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
    var roots:[String:NavContext] = [:]
    
    static let shared = NavContextManager()
    var contextCounter = 0
    var locked = false
    
}
extension NavContextManager{
   
    func contextRoot(fromViewController viewController:UIViewController)->NavContext?{
        let filtered = roots.filter{ $0.value.viewController() == viewController}
        assert(filtered.count <= 1,"there should be only one match")
        return filtered.first?.value
    }
    
    public func contextRoot(forLayer layer:String)->NavContext?{
        return roots[layer]
    }
    
    @discardableResult
    public func contextRoot(forLayer layer:String, viewController:UIViewController) -> NavContext{
        
        let aContext = context( layer:layer, controller: ROOT_CONTROLLER, resourceId: nil, info: nil)
        aContext.setViewController(weak: viewController)
        roots[layer] = aContext
        
        return aContext
    }
    
    public func context(layer:String, controller:String, resourceId:String?,  info:Any?, animator:NavAnimatorClass? = nil, presentation:NavPresentationClass? = nil, _ callback:NavContextCallback? = nil) -> NavContext{
        
        let contextId = self.nextId()
        let context = NavContext(id: contextId, layer:layer, controller: controller, resourceId: resourceId, info: info, animator: animator, callback)
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
        
        context.setViewControllerWeak(true)
        contexts[context.contextId] = nil
    }

}

extension NavContextManager{
    
    func context(fromStateHash hash:String)->NavContext{
        
        let info =  NavSerializer.stringToDict(hash)
        let contextId = info["contextId"] as! String
        return context(fromContextId: Int(contextId)!)
    }
    
    func navigator(fromStateHash hash:String)->NavigatorType{
        
        let info =  NavSerializer.stringToDict(hash)
        let navigator = info["navigator"] as! String
        return NavigatorType(rawValue: navigator)!
    }
    
    func stateHash(from context:NavContext, navigator:NavigatorType)->String{
        
        let info = [
            "controller":context.controller,
            "resourceId":context.resourceId,
            "contextId":String(context.contextId),
            "navigator":navigator.rawValue
        ]
        
        return  NavSerializer.dictToString(info as NSDictionary)
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
