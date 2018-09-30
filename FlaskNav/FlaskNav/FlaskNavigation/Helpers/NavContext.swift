//
//  NavContext.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public enum NavContextType:String,Codable {
    case Root,Push,Pop
}

public struct NavContext:Codable {
    
    enum CodingKeys: String, CodingKey {
        case intention,animation,controller,resourceId,contextId
    }
    
    weak var viewController:UIViewController?
    public let animation:NavigationAnimations
    public var intention:NavContextType
    public let controller:String
    public let resourceId:String?
    public let contextId:Int
    
    public init(intention:NavContextType , controller:String, resourceId:String?,  info:Any?, animation:NavigationAnimations = .Default, _ callback:NavContextCallback? = nil){
        
        self.contextId = NavContextManager.shared.nextId()
        NavContextManager.shared.setInfo(contextId: self.contextId, info)
        NavContextManager.shared.setClosure(contextId: self.contextId, callback)
        
        self.animation = animation
        self.controller = controller
        self.resourceId = resourceId
        self.intention = intention
    }
    
    public init(fromString json:String){
        
        do {
            let jsonData = json.data(using: .utf8)!
            let instance:NavContext = try JSONDecoder().decode(NavContext.self, from: jsonData)
            
            self.contextId = instance.contextId
            self.animation = instance.animation
            
            self.controller = instance.controller
            self.resourceId = instance.resourceId
            self.intention = instance.intention
            
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
    
    //MARK: GETTERS
    public func callback()->NavContextCallback?{
        return  NavContextManager.shared.closure(forContextId: contextId)
    }
    
    public func payload()->Any?{
        return  NavContextManager.shared.info(forContextId: contextId)
    }
    
    public func path()->String {
        if let resourceId = resourceId {
            return "\(controller).\(resourceId)"
        }
        return controller
    }
    
}
