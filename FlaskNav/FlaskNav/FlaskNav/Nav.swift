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


public class FlaskNav<T:Hashable & RawRepresentable, A:Hashable & RawRepresentable > : NSObject, FlaskReactor, UINavigationControllerDelegate{
  
    
    // MARK: NAV CONTROLLER
    
    var window: UIWindow?
    var navController: UINavigationController?
    var cachedControllers:[String:NavWeakRef<UIViewController>] = [:]
    
    // MARK: ROUTING
    
    let navigation = NavigationSubstance()

    public var viewControllers:[T:ControllerConstructor] = [:]
    
    public var accesoryControllers:[A :ControllerConstructor] = [:]
    public var accesoryParents:[A: [T]] = [:]
    public var accesoryLayer:[ A : AccesoryLayers ] = [:]
    
    var _controllers:[String:ControllerConstructor] = [:]
    
    
    override init() {
        super.init()
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
    
    
    //MARK: delegates
    
    var locks:[FluxLock] = []
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if let lock = locks.popLast() {
            lock.release()
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
}

extension FlaskNav{
    
    func controllerConstructor(for controller:String)->ControllerConstructor{
        if let constructor = _controllers[controller]{
            return constructor
        }
        fatalError("constuctor for `\(controller)` not defined")
    }
    
    func cachedControllerFrom(context:NavigationContext)->(controller:UIViewController,cached:Bool){
    
        let key = context.toString()
        if let value = cachedControllers[key]?.value{
           return (controller:value, cached:true)
        }
        
        let constructor = controllerConstructor(for: context.controller)
        let instance = constructor(context)
        
        cachedControllers[key] = NavWeakRef(value:instance)
        
        return (controller:instance, cached:false)
        
    }
    
}

extension FlaskNav{

    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentController){[weak self] (change) in
            
           self?.navigateToCurrentController()
            
        }
    }
    
}
extension FlaskNav{
    
    public func popToRootController(){
        let context = NavigationContext( controller: ROOT_CONTROLLER, resourceId: nil, payload: nil)
        
        Flask.applyMixer(NavigationMixers.Controller, payload: ["context":context.toString()])
        
    }
    
    public func push(controller:T, payload:AnyCodable? = nil){
        push(controller:controller,resourceId:nil,payload:payload)
    }
    public func push(controller:T, resourceId:String?, payload:AnyCodable? = nil){
        
        let stringController = controller.rawValue as! String
        let context = NavigationContext( controller: stringController, resourceId: resourceId, payload: payload)
        
        Flask.applyMixer(NavigationMixers.Controller, payload: ["context":context.toString()])
        
        
    }
}

extension FlaskNav{
    
    public func push(accesory:A, payload:AnyCodable? = nil){
        let stringAccesory = accesory.rawValue as! String
        let context = NavigationContext(controller: stringAccesory, resourceId: nil, payload: payload)
        
        Flask.applyMixer(NavigationMixers.Controller, payload: ["context":context.toString()])
        
        
    }
}

extension FlaskNav{
    
    
    public func setup(withWindow aWindow:UIWindow){
        
        assert(window == nil, "This instance is already setup")
        window = aWindow
        
        let rootController = self.rootController()
        navController = UINavigationController(rootViewController: rootController)
        navController?.setNavigationBarHidden(self.navBarHidden(), animated: false)
        navController?.delegate = self
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    

    
}

extension FlaskNav {

    func presentRootView(){
        //TODO: animated parametrization?
        navController?.popToRootViewController(animated:false)
    }
    
    func navigateToCurrentController(){
        
        let stringContext = navigation.state.currentController
        let context = NavigationContext(fromString: stringContext)

        guard context.controller != ROOT_CONTROLLER else{
            presentRootView()
            return
        }
        
        let cache = cachedControllerFrom(context: context)
       
        cache.controller.view.backgroundColor = .red
    
        if (cache.cached){
            popToController(cache.controller,context: context)
        }else{
            pushController(cache.controller, context: context)
        }
 
    }
    
    func pushController(_ controller:UIViewController, context:NavigationContext){
        DispatchQueue.main.async { [weak self] in
            let animated = context.animation != .None
            self?.navController?.pushViewController(controller, animated: animated)
            
        }
    }
    
    func popToController(_ controller:UIViewController,  context:NavigationContext){
        DispatchQueue.main.async { [weak self] in
            let animated = context.animation != .None
            self?.navController?.popToViewController(controller, animated: animated)
        }
    }
  
}

extension FlaskNav {
    
    
    func presentAccessory(_ controller:UIViewController,  context:NavigationContext){
        
    }
    

}


