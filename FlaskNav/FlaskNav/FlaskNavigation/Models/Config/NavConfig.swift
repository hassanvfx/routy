//
//  NavConfig.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/1/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class NavConfig {
    var navBar:Bool
    var navBarAnimated:Bool = false
    var tabBar:Bool
    var constructor:ControllerConstructor? = nil
    
    public init(navBar:Bool = false, tabBar:Bool = false) {
        self.navBar = navBar
        self.tabBar = tabBar
    }
}
