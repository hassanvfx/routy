//
//  NavActiveLayer.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavActiveLayer {
    public private(set) var active:String = NavLayer.NAV.rawValue
    public private(set) var inactive:String = NavLayer.NAV.rawValue
    
    public private(set) var activeCaptured:String?
    public private(set) var inactiveCaptured:String?
    
    public var onActiveChange:()->Void = {}

    public func setActive(layer:String){
        inactive = active
        active = layer
        
        onActiveChange()
    }
    
    public func restoreActive(){
        active = inactive
    }

    func capture(){
        assert(activeCaptured == nil , "State already captured")
        activeCaptured = active
        inactiveCaptured = inactive
    }
    
    func rollback(){
        assert(activeCaptured != nil , "State not captured")
        active = activeCaptured!
        inactive = inactiveCaptured!
    }
    
    func commit(){
        assert(activeCaptured != nil , "State not captured")
        activeCaptured = nil
        inactiveCaptured = nil
    }
}
