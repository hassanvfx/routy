//
//  NavContext.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavContextManager {
    
    var payloads:[Int:Any?] = [:]
    
    static let shared = NavContextManager()
    var contextCounter = 0
    var locked = false
    
    func nextId()->Int{
        assert(locked == false, "this method is not thread safe")
        locked = true
        defer {
            locked = false
        }
        
        contextCounter+=1
        return contextCounter
    }
    
    func setInfo(contextId:Int,_ payload:Any?){
        payloads[contextId] = payload
    }
    
    func info(forContextId contextId:Int)->Any?{
        return payloads[contextId] ?? nil
    }
}

public struct NavContext:Codable {
    
    enum CodingKeys: String, CodingKey {
        case animation,controller,resourceId,contextId
    }
    
    
    public let animation:NavigationAnimations
    
    public let controller:String
    public let resourceId:String?
    public let contextId:Int
    
    public init(controller:String, resourceId:String?,  info:Any?, animation:NavigationAnimations = .Default){
        
        self.contextId = NavContextManager.shared.nextId()
        NavContextManager.shared.setInfo(contextId: self.contextId, info)
        
        self.animation = animation
        self.controller = controller
        self.resourceId = resourceId
        
    }
    
    public init(fromString json:String){
        
        do {
            let jsonData = json.data(using: .utf8)!
            let instance:NavContext = try JSONDecoder().decode(NavContext.self, from: jsonData)
            
            self.contextId = instance.contextId
            self.animation = instance.animation
            
            self.controller = instance.controller
            self.resourceId = instance.resourceId
            
            
        }catch{
            fatalError("Serialization error")
        }
    }
    
    public func payload()->Any?{
        return  NavContextManager.shared.info(forContextId: self.contextId)
        
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
