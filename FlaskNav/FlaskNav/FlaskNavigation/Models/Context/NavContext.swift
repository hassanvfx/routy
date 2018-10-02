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
    
    public let animation:NavigationAnimations
    public let layer:String
    public let controller:String
    public let resourceId:String?
    public let contextId:Int
    public let info:Any?
    public let callback:NavContextCallback?
    public var navigator:NavigatorType?
    
    init(id contextId: Int, layer:String, controller:String, resourceId:String?,  info:Any?, animation:NavigationAnimations = .Default, _ callback:NavContextCallback? = nil){
        
        self.contextId = contextId
        self.info = info
        self.callback = callback
        self.animation = animation
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
    
}
