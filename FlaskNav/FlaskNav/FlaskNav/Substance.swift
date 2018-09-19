//
//  Substance.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/18/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask


struct NavigationState: State {
    
    enum prop : StateProp{
        case currentController
    }
    var currentController = ROOT_CONTROLLER_ROUTE
    var currentAccesory:String? = nil
}

