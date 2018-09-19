//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


public typealias NavConstructor = () -> UIViewController
public typealias RoutingMap = [String:NavConstructor]

public protocol NavigationInfo{
    associatedtype Routes
    
    var router:RoutingMap {get set}
    func  navBarHidden()->Bool
    func  rootViewController<T:UIViewController>()->T;
    
}

extension NavigationInfo{
    func  navBarHidden()->Bool{
        return true
    }
}

