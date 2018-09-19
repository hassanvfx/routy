//
//  FlaskNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

let UNDEFINED_CONTEXT_ID = -1


public class FlaskNav<T:Hashable & RawRepresentable> : FlaskReactor{
  
    
    // MARK: NAV CONTROLLER
    
    var window: UIWindow?
    var navController: UINavigationController?
    var stack:[String] = []
    
    // MARK: ROUTING
    
    let navigation = NewSubstance(definedBy: NavigationState.self)

    public var router:[T:NavConstructor] = [:]
    var _router:[String:NavConstructor] = [:]
    
    var transitionContexts:[Int:NavigationContext] = [:]
 
    init() {
        configRouter()
        updateRouter()
        AttachFlaskReactor(to: self, mixing: [navigation])
    }
    
    public func updateRouter(){
        
        _router = [:]
        
        for (key,value) in router {
            let stringKey = key.rawValue as! String
            _router[stringKey] = value
        }
    }
    
    // MARK: OPEN OVERRIDES
    
    open func configRouter(){
        //user should define routes using router[.Foo] = Closure
    }
    
    
    open func  navBarHidden()->Bool{
        return true
    }
    
    open func  rootViewController<T:UIViewController>()->T{
        return UIViewController() as! T
    }
    
    
}

extension FlaskNav{
    
    public func constructorFor(_ path:String)->NavConstructor{
        if let constructor = _router[path]{
            return constructor
        }
        fatalError("constuctor `\(path)` not defined")
    }
}

extension FlaskNav{

    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentRoute){[weak self] (change) in
            
            self?.presentRoute(navigation.state.currentRoute )
            
        }
    }
    public func push(path:T, payload:Any? = nil){
        push(resource:path,resourceId:nil,payload:payload)
    }
    public func push(resource:T, resourceId:String?, payload:Any? = nil){
        
        let stringResource = resource.rawValue as! String
        
        var route = NavigationRoute(resource: stringResource, resourceId: resourceId)
        let context = NavigationContext(payload: payload, transition: .push)
        route.contextId = startTransition(context: context)
        
        GetFlaskReactor(at: self).toMix(navigation) { (substance) in
            substance.prop.currentRoute = route.toString()
        }.andReact()
        
    }
}
extension FlaskNav{

    func startTransition(context:NavigationContext)->Int{
        
        let index = transitionContexts.count
        guard transitionContexts[index] == nil else{
            fatalError("unexpected keyspace collision")
        }
        
        transitionContexts[index] = context
        return index
    }
    
    func finishTransition(contextIndex index: Int)->NavigationContext{
        let value = transitionContexts[index]
        transitionContexts.removeValue(forKey: index)
        
        if let value = value {
            return value
        }
        fatalError("index not found")
    }
    
    
}
extension FlaskNav{
    
    
    public func setup(withWindow aWindow:UIWindow){
        
        assert(window == nil, "This instance is already setup")
        window = aWindow
        
        let rootController = self.rootViewController()
        navController = UINavigationController(rootViewController: rootController)
        navController?.setNavigationBarHidden(self.navBarHidden(), animated: false)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    

    func presentRoute(_ aRoute:String){
       
        let route = NavigationRoute.init(fromString: aRoute)
        let context = finishTransition(contextIndex: route.contextId)
        let payload = NavigationPayload(context: context, route: route)
        
        let constructor = constructorFor(route.resource)
        let controller = constructor(payload)
        controller.view.backgroundColor = .red
       
        navController?.pushViewController(controller, animated: true)
        
    }
}
