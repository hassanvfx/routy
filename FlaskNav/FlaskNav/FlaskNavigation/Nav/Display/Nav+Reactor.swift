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
       
        var lockHandled = false
        // ACTIVE LAYER
        reaction.on(NavigationState.prop.layerActive){[weak self] (change) in
            print("dispatch reaction on Active Layer")
            self?.displayComposition(fluxLock: reaction.onLock!)
            lockHandled = true
        }
        
        // MODAL COMP
        reaction.on(NavigationState.prop.modal){[weak self] (change) in
            print("dispatch reaction on Modal Composition")
            self?.displayModal(fluxLock: reaction.onLock!)
            lockHandled = true
        }
        
        // MAIN NAV
        reaction.on(NavLayer.LayerNav()){[weak self] (change) in
            print("dispatch reaction on Nav")
            self?.navigateToController(layer:NavLayer.Nav(), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        
        // MODAL
        reaction.on(NavLayer.LayerModal()){[weak self] (change) in
            print("dispatch reaction on Modal Navigation")
            self?.navigateToController(layer:NavLayer.Modal(), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        
        // TABS
        reaction.on(NavLayer.LayerTab(0)){[weak self] (change) in
            print("dispatch reaction on Tab0")
            self?.navigateToController(layer:NavLayer.Tab(0), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(1)){[weak self] (change) in
            print("dispatch reaction on Tab1")
            self?.navigateToController(layer:NavLayer.Tab(1), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(2)){[weak self] (change) in
            print("dispatch reaction on Tab2")
            self?.navigateToController(layer:NavLayer.Tab(2), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(3)){[weak self] (change) in
            print("dispatch reaction on Tab3")
            self?.navigateToController(layer:NavLayer.Tab(3), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(4)){[weak self] (change) in
            print("dispatch reaction on Tab4")
            self?.navigateToController(layer:NavLayer.Tab(4), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(5)){[weak self] (change) in
            print("dispatch reaction on Tab5")
            self?.navigateToController(layer:NavLayer.Tab(5), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(6)){[weak self] (change) in
            print("dispatch reaction on Tab6")
            self?.navigateToController(layer:NavLayer.Tab(6), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(7)){[weak self] (change) in
            print("dispatch reaction on Tab7")
            self?.navigateToController(layer:NavLayer.Tab(7), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(8)){[weak self] (change) in
            print("dispatch reaction on Tab8")
            self?.navigateToController(layer:NavLayer.Tab(8), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(9)){[weak self] (change) in
            print("dispatch reaction on Tab9")
            self?.navigateToController(layer:NavLayer.Tab(9), fluxLock: reaction.onLock!)
            lockHandled = true
        }
        
        reaction.on(NavigationState.prop.layers){ (change) in
            if !lockHandled {
                print("dispatch [not handled] reaction on Layers")
                reaction.onLock?.autorelease()
            }
        }
    }
}

