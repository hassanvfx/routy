//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


public protocol NavigationInfo{
    func  navBarHidden()->Bool
    func  rootViewController<T:UIViewController>()->T;
    
}

extension NavigationInfo{
    func  navBarHidden()->Bool{
        return true
    }
}

