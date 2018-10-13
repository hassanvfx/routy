//
//  NavContext.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public enum NavigatorType:String,Codable {
    case Root,Push,Pop
}

public class NavContext {
    
    static let manager = NavContextManager()
    
    weak var viewControllerWeak:UIViewController? = nil
    var viewControllerStrong:UIViewController? = nil
    

    public let layer:String
    public let controller:String
    public let resourceId:String?
    public let contextId:Int
    public let info:Any?
    
    public var navigator:NavigatorType
    public var animator:NavAnimatorClass?
    
    public var capturedState = false
    public var capturedNavigator:NavigatorType?
    public var capturedAnimator:NavAnimatorClass?
    
    init(id contextId: Int, layer:String, navigator:NavigatorType, controller:String, resourceId:String?,  info:Any?, animator:NavAnimatorClass? = nil){
        
        self.navigator = navigator
        self.contextId = contextId
        self.info = info
        self.animator = animator
        self.controller = controller
        self.resourceId = resourceId
        self.layer = layer
    }
    
    
    public func path()->String {
        if let resourceId = resourceId {
            return "\(controller).\(resourceId)"
        }
        return controller
    }
    
    public func desc()->String {
        return "[[ CTX:\(contextId).\(String(describing: navigator)).\(layer).\(controller).\(String(describing: resourceId)) ]]"
    }
    
    public func operationName()->String {
        return "cid:\(contextId)->\(path)"
    }
    
    public func setViewControllerWeak(_ explicit:Bool = false){
        if(!explicit){
            assert(viewControllerStrong != nil,"called to set weak but strong is nil")
        }
        viewControllerWeak = viewControllerStrong
        viewControllerStrong = nil
    }
    
    public func setViewController(weak viewController:UIViewController?){
        viewControllerWeak = viewController
        viewControllerStrong = nil
    }
    
    public func setViewController(strong viewController:UIViewController){
        viewControllerWeak = viewController
        viewControllerStrong = viewController
    }
    
    public func viewController()->UIViewController?{
        if let strong = viewControllerStrong {
            return strong
        }
        
        return viewControllerWeak
    }
    
    public func captureState(){
        assert(capturedState == false, "state already captured")
        capturedState = true
        capturedNavigator = navigator
        capturedAnimator = animator
    }
    
    public func rollbackState(){
        assert(capturedState == true, "state not captured")
        capturedState = false
        navigator = capturedNavigator!
        animator = capturedAnimator
    }
    
    public func commitState(){
        assert(capturedState == true, "state not captured")
        capturedState = false
        capturedNavigator = nil
        capturedAnimator = nil
    }
    
}
