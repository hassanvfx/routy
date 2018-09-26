//
//  NavInfo.swift
//  Roots
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public struct NavInfo:CodableInfo {
    var name:String?
    var resource:String?
    var resourceId:String?
    var params:[String:AnyCodable]?
    var map:[String:AnyCodable]?
    
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
