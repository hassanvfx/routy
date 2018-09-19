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
        case currentPath
    }
    var currentPath = "root"
}

