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

    public var controllers:[T:NavConstructor] = [:]
    var _controllers:[String:NavConstructor] = [:]
    
    var transitionContexts:[Int:NavigationContext] = [:]
 
    init() {
        _configControllers()
        
        AttachFlaskReactor(to: self, mixing: [navigation])
    }
    
    func _configControllers(){
        controllers = [:]
        defineControllers()
        
        assert(controllers.count > 0, "Ensure to define your controllers using `controllers` example `controllers[.Name] = { (payload) in UIViewController() }`")
        
        mapControllers()
    }
    
    func mapControllers(){
        _controllers = [:]
        
        for (key,value) in controllers {
            let stringKey = key.rawValue as! String
            _controllers[stringKey] = value
        }
    }
    
    // MARK: OPEN OVERRIDES
    
    open func defineControllers(){
        //user should define routes using router[.Foo] = Closure
    }
    
    
    open func  navBarHidden()->Bool{
        return true
    }
    
    open func  rootController()->UIViewController{
        return UIViewController()
    }
    
    
}

extension FlaskNav{
    
    public func controllerConstructor(for path:String)->NavConstructor{
        if let constructor = _controllers[path]{
            return constructor
        }
        fatalError("constuctor `\(path)` not defined")
    }
}

extension FlaskNav{

    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentRoute){[weak self] (change) in
            
            self?.presentController(navigation.state.currentRoute )
            
        }
    }
    
    
    public func push(controller:T, payload:Any? = nil){
        push(controller:controller,resourceId:nil,payload:payload)
    }
    public func push(controller:T, resourceId:String?, payload:Any? = nil){
        
        let stringController = controller.rawValue as! String
        
        var route = NavigationRoute(controller: stringController, resourceId: resourceId)
        let context = NavigationContext(payload: payload, navigationType: .push)
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
        
        let rootController = self.rootController()
        navController = UINavigationController(rootViewController: rootController)
        navController?.setNavigationBarHidden(self.navBarHidden(), animated: false)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    

    func presentController(_ aRoute:String){
       
        let route = NavigationRoute.init(fromString: aRoute)
        let context = finishTransition(contextIndex: route.contextId)
        let payload = NavigationPayload(context: context, route: route)
        
        let constructor = controllerConstructor(for: route.controller)
        let controller = constructor(payload)
        controller.view.backgroundColor = .red
       
        switch context.navigationType {
        case .pop:
            break;
        case .push:
            break;
        }
        
        navController?.pushViewController(controller, animated: true)
        
    }
}
