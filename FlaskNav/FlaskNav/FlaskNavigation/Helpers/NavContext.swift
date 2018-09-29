//
//  NavContext.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public struct NavContext:Codable {
    
    public var _payload:String?
    public let animation:NavigationAnimations
    
    public let controller:String
    public let resourceId:String?
    
    
    public init(controller:String, resourceId:String?,  info:CodableInfo?, animation:NavigationAnimations = .Default){
        self.animation = animation
        self.controller = controller
        self.resourceId = resourceId
        self._payload = nil
        
        if let info = info {
            self._payload = info.asJSONString()
        }
    }
    
    public init(fromString json:String){
        
        do {
            let jsonData = json.data(using: .utf8)!
            let instance:NavContext = try JSONDecoder().decode(NavContext.self, from: jsonData)
            
            self._payload = instance._payload
            self.animation = instance.animation
            
            self.controller = instance.controller
            self.resourceId = instance.resourceId
            
        }catch{
            fatalError("Serialization error")
        }
    }
    
    public func payload<T:CodableInfo>()->T?{
        
        guard self._payload != nil else{
            return  nil
        }
        
        return T.instance(withJSON: self._payload!)
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
