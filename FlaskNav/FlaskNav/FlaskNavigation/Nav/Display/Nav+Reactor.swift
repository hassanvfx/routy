//
//  Navigators.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav: FlaskReactor{
    public func flaskReactor(reaction: FlaskReaction) {
        reaction.on(NavigationState.prop.currentController){[weak self] (change) in
            self?.navigateToCurrentController(fluxLock: reaction.onLock!)
        }
    }
}

