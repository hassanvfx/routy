//
//  NavInfo.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public typealias NavInfoCallbackClosure = (_ nav:FlaskNavigationController,_ controller:UIViewController)->Void


public class NavInfo {
    
    var name:String?
    var resource:String?
    var resourceId:String?
    var params:[String:AnyCodable]?
    var map:[String:AnyCodable]?
    
    
    var onWillInit:NavInfoCallbackClosure?
    var onDidInit:NavInfoCallbackClosure?
    
    var onWillSetupEmptyState:NavInfoCallbackClosure?
    var onDidSetupEmptyState:NavInfoCallbackClosure?
    
    var onWillSetupContent:NavInfoCallbackClosure?
    var onDidSetupContent:NavInfoCallbackClosure?
    
    var onDidSetup:NavInfoCallbackClosure?
    
    var callback:NavContextCallback?
    
    init(name:String?=nil,
         resource:String?=nil,
         resourceId:String?=nil,
         params:[String:AnyCodable]?=nil,
         map:[String:AnyCodable]?=nil) {
        
        self.name = name
        self.resource = resource
        self.resourceId = resourceId
        self.params = params
        self.map = map
    }
}
