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
    let CANCELED_OPERATION_NAME = "canceledOperation"
    
    // MARK: NAV CONTROLLER
    
    var window: UIWindow?
    var tabController: UITabBarController?
    var navControllers:[String:FlaskNavigationController] = [:]
    // MARK: STACK
    
    var stackLayers:[String:NavStack] = [:]
    var stackActive:NavActiveLayer = NavActiveLayer()
    
    var composition:NavComposition<TABS,CONT,MODS>?
    var compositionBatch:NavComposition<TABS,CONT,MODS>?
    var compDelegate: NavStackAPI? = nil
    var compBatched: Bool = false
    
    // MARK: ANIMATIONS
    var animators:[String:NavAnimatorClass] = [:]
    var modalPresentator:NavPresentator?
    var tabPresentator:NavPresentator?
    
    // MARK: CONFIG
    
    let substance = NavigationSubstance()

    // main nav
    var navRoot:ControllerConstructor? = nil
    var navRootConfig:NavConfig? = nil
    var modalRootConfig:NavConfig = NavConfig(navBar: true, tabBar:true)
    
    // tabs
    var tabs:[Int:ControllerConstructor] = [:]
    var tabsConfig:[Int:NavConfig] = [:]
    var tabsNameMap:[Int:String] = [:]
    var tabsIndexMap:[String:Int] = [:]
    
    // content
    var controllers:[String:ControllerConstructor] = [:]
    var modals:[String:ControllerConstructor] = [:]
    
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
        
        setupActiveLayer()
        setupCompositionAPI()

        Flask.attachReactor(to: self, mixing: [substance])
        
        configRouter()
    }
    
    func setupActiveLayer(){
        stackActive.onActiveChange = { [weak self] in
            self?.flushModalStack()
        }
    }
    
    func setupCompositionAPI(){
        composition = NavComposition<TABS,CONT,MODS>(delegate: self)
        compositionBatch = NavComposition<TABS,CONT,MODS>(batch: true, delegate: self)
    }
    // MARK: OPEN OVERRIDES
    open func defineRouting(){}
    
    /// Should define the NavigationBar visibility
    /// - Returns: Boolean
    open func  navBarHidden()->Bool{
        return true
    }

    //MARK: NavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        intentToCompleteOperationFor(controller: viewController)
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    //MARK: ANIMATORS
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return preferredAnimator(for: navigationController,animationControllerFor: operation, from: fromVC, to:toVC )
        
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        
        guard let animator = animationController as? NavAnimatorClass else{ return nil }
        
        guard let interactor =  animator.interactionStart() else { return nil }

        return interactor
    }
    
    
}
