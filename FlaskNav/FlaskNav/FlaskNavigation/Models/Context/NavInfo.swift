//
//  NavInfo.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public typealias NavInfoCallbackClosure = (_ nav:FlaskNavigationController,_ context:NavContext)->Void


public class NavInfo {
    
    var name:String?
    var resource:String?
    var resourceId:String?
    var params:[String:Any?]?
    var map:[String:Any?]?
    
    
    var onWillInit:NavInfoCallbackClosure?
    var onDidInit:NavInfoCallbackClosure?
    
    var onWillSetupEmptyState:NavInfoCallbackClosure?
    var onDidSetupEmptyState:NavInfoCallbackClosure?
    
    var onWillSetupContent:NavInfoCallbackClosure?
    var onDidSetupContent:NavInfoCallbackClosure?
    
    var onDidSetup:NavInfoCallbackClosure?
    
    public private(set) var _callback:NavContextCallback?
    var context:NavContext?
    
    init(name:String? = nil,
         resource:String? = nil,
         resourceId:String? = nil,
         params:[String:Any?]? = nil,
         map:[String:Any?]? = nil,
         callback:NavContextCallback? = nil) {
        
        self.name = name
        self.resource = resource
        self.resourceId = resourceId
        self.params = params
        self.map = map
        self._callback = callback
    }
    
    func getCallback()->NavContextCallback?{
       return _callback
    }
    
    func callback(_ payload:Any?){
        guard let context = context else { assert(false,"context not set!");  return }
        _callback?( context, payload)
    }
    
    func setCallback(_ action:@escaping NavContextCallback){
        _callback = action
    }
}
