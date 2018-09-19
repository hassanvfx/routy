//
//  FlaskNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

public class FlaskNav<T:Hashable & RawRepresentable> : FlaskReactor{
  
    let navigation = NewSubstance(definedBy: NavigationState.self)

    public var router:[T:NavConstructor] = [:]
    var _router:[String:NavConstructor] = [:]
    
    var window: UIWindow?
    var navController: UINavigationController?
    var stack:[String] = []
    
    init() {
        configRouter()
        updateRouter()
        AttachFlaskReactor(to: self, mixing: [navigation])
    }
    
    open func configRouter(){
        //user should define routes using router[.Foo] = Closure
    }
    
    public func updateRouter(){
        
        _router = [:]
        
        for (key,value) in router {
            let stringKey = key.rawValue as! String
            _router[stringKey] = value
        }
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
        fatalError("constuctor not defined")
    }
}

extension FlaskNav{

    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentPath){[weak self] (change) in
            
            self?.presentController(path: navigation.state.currentPath )
            
        }
    }
    
    public func push(path:T){
        
        let stringPath = path.rawValue as! String
        
        GetFlaskReactor(at: self).toMix(navigation) { (substance) in
            substance.prop.currentPath = stringPath
        }.andReact()
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
    
    
    
    func  presentController(path:String){
       
        let constructor = self.constructorFor(path)
        let controller = constructor()
        controller.view.backgroundColor = .red
        navController?.pushViewController(controller, animated: true)
        
    }
}
