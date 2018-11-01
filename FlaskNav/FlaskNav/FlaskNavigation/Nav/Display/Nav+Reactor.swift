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
            
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Active Layer")
                self?.displayComposition(fluxLock: lock)
            }
            lockHandled = true
        }
        
        // MODAL COMP
        reaction.on(NavigationState.prop.modal){[weak self] (change) in
            
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Modal Composition")
                self?.displayModal( fluxLock: lock)
            }
            lockHandled = true
        }
        
        // MAIN NAV
        reaction.on(NavLayer.LayerNav()){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Nav")
                self?.navigateToController(layer:NavLayer.Nav(), fluxLock: lock)
                lockHandled = true
            }
        }
        
        // MODAL
        reaction.on(NavLayer.LayerModal()){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Modal Navigation")
                self?.navigateToController(layer:NavLayer.Modal(), fluxLock: lock)
            }
            lockHandled = true
        }
        
        // TABS
        reaction.on(NavLayer.LayerTab(0)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab0")
                self?.navigateToController(layer:NavLayer.Tab(0), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(1)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab1")
                self?.navigateToController(layer:NavLayer.Tab(1), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(2)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab2")
                self?.navigateToController(layer:NavLayer.Tab(2), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(3)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab3")
                self?.navigateToController(layer:NavLayer.Tab(3), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(4)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab4")
                self?.navigateToController(layer:NavLayer.Tab(4), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(5)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab5")
                self?.navigateToController(layer:NavLayer.Tab(5), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(6)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab6")
                self?.navigateToController(layer:NavLayer.Tab(6), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(7)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab7")
                self?.navigateToController(layer:NavLayer.Tab(7), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(8)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab8")
                self?.navigateToController(layer:NavLayer.Tab(8), fluxLock: lock)
            }
            lockHandled = true
        }
        reaction.on(NavLayer.LayerTab(9)){[weak self] (change) in
            reactInQueue(lock: reaction.onLock!){ lock in
                print("REACT reaction on Tab9")
                self?.navigateToController(layer:NavLayer.Tab(9), fluxLock: lock)
            }
            lockHandled = true
        }
        
        reaction.on(NavigationState.prop.layers){ (change) in
            if !lockHandled {
                reactInQueue(lock: reaction.onLock!){ lock in
                    print("REACT [not handled] reaction on Layers")
                    lock.autorelease()
                }
            }
        }
    }

    func reactInQueue(lock:FluxLock, action:@escaping (FluxLock)->Void){
        lock.inreaseLock()
        
        performInNavQueue{
            print("BOL------")
            action(lock)
            print("EOL------")
        }
    }
}

