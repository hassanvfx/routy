//
//  FlaskNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

public class FlaskNav<TABS:Hashable & RawRepresentable, CONT:Hashable & RawRepresentable,  MODS:Hashable & RawRepresentable > : NSObject, UINavigationControllerDelegate{
  
    let FIRST_NAVIGATION_ROOT_COUNT = 2
    let UNDEFINED_CONTEXT_ID = -1
    
    // MARK: NAV CONTROLLER
    
    var window: UIWindow?
    var navController: UINavigationController?
    var tabController: UITabBarController?
    var tabNavControllers: [Int:UINavigationController] = [:]
    
    // MARK: STACK
    
    var stackLayers:[String:NavStack] = [:]
    var stackActive:String = NavLayer.NAV.rawValue
    var composition:NavComposition<TABS,CONT,MODS>?
    var compositionBatch:NavComposition<TABS,CONT,MODS>?
    var compDelegate: NavStackAPI? = nil
    var compBatched: Bool = false
    
   
    // MARK: CONFIG
    
    let substance = NavigationSubstance()

    public var viewControllers:[CONT:ControllerConstructor] = [:]
    
    
    var navRoot:ControllerConstructor? = nil
    var _controllers:[String:ControllerConstructor] = [:]
    var modals:[String:ControllerConstructor] = [:]
    var tabs:[String:ControllerConstructor] = [:]
    
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
    
    var operations:[Int:[FlaskNavOperation]] = [:]
    
    // MARK : INIT
    
    override init() {
        super.init()
        
        self.composition = NavComposition<TABS,CONT,MODS>(delegate: self)
        self.compositionBatch = NavComposition<TABS,CONT,MODS>(batch: true, delegate: self)
        
        _configControllers()
        
        AttachFlaskReactor(to: self, mixing: [substance])
    }
    
    
    // MARK: OPEN OVERRIDES
    
    open func defineRouter(){}
    
    /// Should define controllers using controller[.Foo] = Closure
    open func defineControllers(){}
    
    /// Should define controllers using controller[.Foo] = Closure
    open func defineModals(){}
    

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
    public func navigationController(_ substanceController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        completeOperationFor(controller: viewController)
    }
    
    public func navigationController(_ substanceController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
}
