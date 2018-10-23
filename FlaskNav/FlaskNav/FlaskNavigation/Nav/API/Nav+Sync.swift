//
//  Nav+Sync.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


extension FlaskNav{
    
    func flushModalStack(){
        self.stack(forLayer: NavLayer.Modal()).clear()
    }
    
    func syncWithDisplay(_ completion:@escaping ()->Void){
        
//        let aLayer = stackActive.active
//        let aModal = stackActive.modal
//        let stackHash = nil
        let state = substance.state
        
        syncModal()
        syncComposition()
        syncNavStacks()
        
        let newState = NavigationState(layers: state.layers, layerActive: stackActive.active, modal: stackActive.modal)
        substance.captureState(newState: newState) { [weak self] in
            self?.substance.rollbackState(){
                completion()
            }
        }
    }
    
    func syncModal(){
        stackActive.set(modal:  isModalPresented())
        hideEmptyModal()
    }
    
    func syncComposition(){
        
        guard let tab = tabController else { return }
        let index = tab.selectedIndex
        if isTabPresented() {
            stackActive.set(layer: NavLayer.Tab(index))
        }else{
            stackActive.set(layer: NavLayer.Nav())
        }
       
    }
    
    func syncNavStacks(){
        //check the count of all tab-navs
        //check main nav
        //check modal
    }
    
    
    func hideEmptyModal(){
        
        let stack = self.stack(forLayer: NavLayer.Modal())
        if stack.isEmpty() {
            stackActive.hideModal()
        }
        
    }
}

