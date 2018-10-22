//
//  Nav+Presentators.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/11/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav {
    
    func displayModal(fluxLock:FluxLock){
        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: substance.state.layerActive )
      
        let modal = substance.state.modal
        
        if modal{
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.displayModalOperation {
                    //there is no way to cancel this animator
                    completion(true)
                }
            })
        } else {
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.dismissModalOperation {
                     //there is no way to cancel this animator
                    completion(true)
                }
            })
        }
    }
    
    func displayComposition(fluxLock:FluxLock){

        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: substance.state.layerActive )
        let activeLayer = substance.state.layerActive
        
        if NavLayer.IsNav(activeLayer){
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.dismissTabOperation { completed in
                    completion(completed)
                }
            })
            
        } else if  NavLayer.IsTab(activeLayer){
            let index = NavLayer.TabIndex(substance.state.layerActive)
            
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.displayTabOperation(index) { completed in
                    completion(completed)
                }
            })
            
        }
        
        
        
    }
    
}
