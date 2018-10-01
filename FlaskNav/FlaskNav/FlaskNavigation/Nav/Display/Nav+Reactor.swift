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
       
        // ACTIVE LAYER
        reaction.on(NavigationState.prop.layerActive){[weak self] (change) in
            self?.applyNavType(fluxLock: reaction.onLock!)
        }
        
        // MAIN NAV
        reaction.on(NavLayer.LayerNav()){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.NAV.rawValue, fluxLock: reaction.onLock!)
        }
        
        // MODAL
        reaction.on(NavLayer.LayerModal()){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.NAV.rawValue, fluxLock: reaction.onLock!)
        }
        
        // TABS
        reaction.on(NavLayer.LayerTab(0)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB0.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(1)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB1.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(2)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB2.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(3)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB3.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(4)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB4.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(5)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB5.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(6)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB6.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(7)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB7.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(8)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB8.rawValue, fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(9)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.TAB9.rawValue, fluxLock: reaction.onLock!)
        }
        
    }
}

