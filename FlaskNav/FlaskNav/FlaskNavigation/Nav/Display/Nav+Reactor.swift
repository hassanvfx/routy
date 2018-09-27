//
//  Navigators.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension Roots: FlaskReactor{
    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentController){[weak self] (change) in
            self?.navigateToCurrentController(fluxLock: reaction.onLock!)
        }
        
        reaction.on(NavigationState.prop.navType){[weak self] (change) in
            self?.applyNavType(fluxLock: reaction.onLock!)
        }
    }
}

