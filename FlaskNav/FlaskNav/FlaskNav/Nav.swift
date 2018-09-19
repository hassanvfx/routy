//
//  FlaskNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class FlaskNav<T:Hashable> {

    var router:[T:NavConstructor] = [:]
    
    var window: UIWindow?
    var navController: UINavigationController?
    var stack:[String] = []
    
    init() {
        configRouter()
    }
    
    open func configRouter(){}

    

    open func  navBarHidden()->Bool{
        return true
    }
    open func  rootViewController<T:UIViewController>()->T{
        return UIViewController() as! T
    }
    
    
}

extension FlaskNav{
    
    public func constructorFor(_ path:T)->NavConstructor{
        if let constructor = router[path]{
            return constructor
        }
        fatalError("constuctor not defined")
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
    
    public func presentController(path:T){
        
        let constructor = self.constructorFor(path)
        let controller = constructor()
        controller.view.backgroundColor = .red
        navController?.pushViewController(controller, animated: true)
        
    }
}
