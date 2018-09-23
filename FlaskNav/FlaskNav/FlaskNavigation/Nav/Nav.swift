//
//  FlaskNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

public class FlaskNav<T:Hashable & RawRepresentable, A:Hashable & RawRepresentable > : NSObject, UINavigationControllerDelegate{
  
    let FIRST_NAVIGATION_ROOT_COUNT = 2
    let UNDEFINED_CONTEXT_ID = -1
    
    // MARK: NAV CONTROLLER
    
    var window: UIWindow?
    var navController: UINavigationController?
    var cachedControllers:[String:NavWeakRef<UIViewController>] = [:]
    
    // MARK: STACK
    
    var stack:[NavigationContext] = []
    
    // MARK: CONFIG
    
    let navigation = NavigationSubstance()

    public var viewControllers:[T:ControllerConstructor] = [:]
    
    public var accesoryControllers:[A :ControllerConstructor] = [:]
    public var accesoryParents:[A: [T]] = [:]
    public var accesoryLayer:[ A : AccesoryLayers ] = [:]
    
    var _controllers:[String:ControllerConstructor] = [:]
    
    // MARK: QUEUE
 
    var didShowRootCounter = 0
    var waitingForContentCompletion = false
    
    let operationQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    let contentQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    var operations:[String:[FlaskNavOperation]] = [:]
    
    // MARK : INIT
    
    override init() {
        super.init()
        _configControllers()
        
        AttachFlaskReactor(to: self, mixing: [navigation])
    }
    
    
    // MARK: OPEN OVERRIDES
    
    /// Should define controllers using controller[.Foo] = Closure
    open func defineControllers(){}
    
    /// Should define controllers using controller[.Foo] = Closure
    open func defineAccesories(){}
    

    /// Should define the NavigationBar visibility
    ///
    /// - Returns: Boolean
    open func  navBarHidden()->Bool{
        return true
    }
    
    /// Should define the Root controller consturctor
    ///
    /// - Returns: UIViewController instance
    open func  rootController()->UIViewController{
        return UIViewController()
    }
    
    
    //MARK: NavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        completeOperationFor(controller: viewController)
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
}









