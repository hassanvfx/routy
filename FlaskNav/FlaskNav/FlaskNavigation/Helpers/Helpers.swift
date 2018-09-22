//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


let ROOT_CONTROLLER = "root"

public typealias ControllerConstructor = () -> UIViewController
public typealias RoutingMap = [String:ControllerConstructor]


public class NavWeakRef<T> where T: AnyObject {
    
    private(set) weak var value: T?
    
    init(value: T?) {
        self.value = value
    }
}

public enum AccesoryLayers:Int {
    case First, Second, Third, Fourth, Fifth, Sixth, Seventh, Eighth, Ninth, Tenth
}

public enum NavigationType:String,Codable {
    case Accesory,PushController,PopToController
}

public enum NavigationAnimations:String,Codable {
    case None, Default
}

public struct NavigationContext:Codable {
    
    public let payload:[String:AnyCodable]?
    public let animation:NavigationAnimations
    
    public let controller:String
    public let resourceId:String?
  
    
    public init(controller:String, resourceId:String?,  payload:[String:AnyCodable]?, animation:NavigationAnimations = .Default){
        self.animation = animation
        self.payload = payload
        self.controller = controller
        self.resourceId = resourceId
    }
    
    public init(fromString json:String){
        
        do {
            let jsonData = json.data(using: .utf8)!
            let instance:NavigationContext = try JSONDecoder().decode(NavigationContext.self, from: jsonData)
            
            self.payload = instance.payload
            self.animation = instance.animation
            
            self.controller = instance.controller
            self.resourceId = instance.resourceId
            
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
    
    public func path()->String {
        if let resourceId = resourceId {
            return "\(controller).\(resourceId)"
        }
        return controller
    }
    
}



