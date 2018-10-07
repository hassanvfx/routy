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
    
    public func flaskReactions(reaction: FlaskReaction) {
       
        // ACTIVE LAYER
        reaction.on(NavigationState.prop.layerActive){[weak self] (change) in
            self?.applyNavType(fluxLock: reaction.onLock!)
        }
        
        // MAIN NAV
        reaction.on(NavLayer.LayerNav()){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Nav(), fluxLock: reaction.onLock!)
        }
        
        // MODAL
        reaction.on(NavLayer.LayerModal()){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Modal(), fluxLock: reaction.onLock!)
        }
        
        // TABS
        reaction.on(NavLayer.LayerTab(0)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(0), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(1)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(1), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(2)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(2), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(3)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(3), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(4)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(4), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(5)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(5), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(6)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(6), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(7)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(7), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(8)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(8), fluxLock: reaction.onLock!)
        }
        reaction.on(NavLayer.LayerTab(9)){[weak self] (change) in
            self?.navigateToController(layer:NavLayer.Tab(9), fluxLock: reaction.onLock!)
        }
        
    }
}

