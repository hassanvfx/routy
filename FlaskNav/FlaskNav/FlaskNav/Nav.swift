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


public class FlaskNav<T:Hashable & RawRepresentable, A:Hashable & RawRepresentable > : FlaskReactor{
  
    
    // MARK: NAV CONTROLLER
    
    var window: UIWindow?
    var navController: UINavigationController?
    var stack:[String] = []
    
    // MARK: ROUTING
    
    let navigation = NewSubstance(definedBy: NavigationState.self)

    public var viewControllers:[T:ControllerConstructor] = [:]
    
    public var accesoryControllers:[A :ControllerConstructor] = [:]
    public var accesoryParents:[A: [T]] = [:]
    public var accesoryLayer:[ A : AccesoryLayers ] = [:]
    
    var _controllers:[String:ControllerConstructor] = [:]
    
    var transitionContexts:[Int:NavigationContext] = [:]
 
    init() {
        _configControllers()
        
        AttachFlaskReactor(to: self, mixing: [navigation])
    }
    
    func _configControllers(){
        viewControllers = [:]
        defineControllers()
        
        assert(viewControllers.count > 0, "Ensure to define your controllers using `controllers` example `controllers[.Name] = { (payload) in UIViewController() }`")
        
        mapControllers()
    }
    
    func _configAccesories(){
        
        defineAccesories()
    }
    
    func mapControllers(){
        _controllers = [:]
        
        for (key,value) in viewControllers {
            let stringKey = key.rawValue as! String
            _controllers[stringKey] = value
        }
    }
    
    // MARK: OPEN OVERRIDES
    
    open func defineControllers(){
        //user should define controllers using controller[.Foo] = Closure
    }
    
    open func defineAccesories(){
        //user should define accesoryController using accesory[.Foo] = Closure
    }
    
    open func  navBarHidden()->Bool{
        return true
    }
    
    open func  rootController()->UIViewController{
        return UIViewController()
    }
    
    
}

extension FlaskNav{
    
    public func controllerConstructor(for path:String)->ControllerConstructor{
        if let constructor = _controllers[path]{
            return constructor
        }
        fatalError("constuctor `\(path)` not defined")
    }
}

extension FlaskNav{

    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentController){[weak self] (change) in
            
            self?.presentController(navigation.state.currentController )
            
        }
    }
    
}
extension FlaskNav{
    
    public func push(controller:T, payload:AnyCodable? = nil){
        push(controller:controller,resourceId:nil,payload:payload)
    }
    public func push(controller:T, resourceId:String?, payload:AnyCodable? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext(payload: payload, navigationType: .push)
        
        var route = NavigationRoute(controller: stringController, resourceId: resourceId)
        route.contextId = startTransition(context: context)
        
        GetFlaskReactor(at: self)
            .toMix(navigation) { (substance) in
                substance.prop.currentController = route.toString()
            }.andReact()
        
    }
}

extension FlaskNav{
    
    public func push(accesory:A, payload:AnyCodable? = nil){
        let stringAccesory = accesory.rawValue as! String
        let context = NavigationContext(payload: payload, navigationType: .push)
        
        var route = NavigationRoute(controller: stringAccesory, resourceId: nil)
        route.contextId = startTransition(context: context)
        
        GetFlaskReactor(at: self)
            .toMix(navigation) { (substance) in
                substance.prop.currentAccesory = route.toString()
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
