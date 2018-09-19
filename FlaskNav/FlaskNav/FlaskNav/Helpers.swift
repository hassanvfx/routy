//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


let ROOT_CONTROLLER_ROUTE = "root"

public typealias ControllerConstructor = (_ payload:NavigationPayload) -> UIViewController
public typealias RoutingMap = [String:ControllerConstructor]

public enum AccesoryLayers:Int {
    case First, Second, Third, Fourth, Fifth, Sixth, Seventh, Eighth, Ninth, Tenth
}

public enum NavigationType:String {
    case push,pop
}

public struct NavigationPayload {
    
    public let context:NavigationContext
    public let route:NavigationRoute
    
    public var object:Any? {
        return context.payload
    }
}

public struct NavigationContext {
    public let payload:Any?
    public let navigationType:NavigationType
}

public struct NavigationRoute:Codable {
    public let controller:String
    public let resourceId:String?
    public var contextId:Int = UNDEFINED_CONTEXT_ID
    
    
    public init(controller:String, resourceId:String?){
        self.controller = controller
        self.resourceId = resourceId
    }
    public init(fromString json:String){
        
        do {
            let jsonData = json.data(using: .utf8)!
            let instance:NavigationRoute = try JSONDecoder().decode(NavigationRoute.self, from: jsonData)
            
            self.controller = instance.controller
            self.resourceId = instance.resourceId
            self.contextId  = instance.contextId
            
            //            return String(data: jsonData, encoding: .utf8)!
        }catch{
            fatalError("Serialization error")
        }
        
        
    }
    public func toString()->String {
        
        do {
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8)!
        }catch{
            fatalError("Serialization error")
        }
    }
}



