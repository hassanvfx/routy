//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


public typealias NavConstructor = (_ payload:NavigationPayload) -> UIViewController
public typealias RoutingMap = [String:NavConstructor]

public enum NavigationTransition:String {
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
    public let transition:NavigationTransition
}

public struct NavigationRoute:Codable {
    public let resource:String
    public let resourceId:String?
    public var contextId:Int = UNDEFINED_CONTEXT_ID
    
    
    public init(resource:String, resourceId:String?){
        self.resource = resource
        self.resourceId = resourceId
    }
    public init(fromString json:String){
        
        do {
            let jsonData = json.data(using: .utf8)!
            let instance:NavigationRoute = try JSONDecoder().decode(NavigationRoute.self, from: jsonData)
            
            self.resource = instance.resource
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



