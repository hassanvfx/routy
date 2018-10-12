//
//  Nav+Presentators.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/11/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav {
    func applyNavType(fluxLock:FluxLock){
        
        
        let navOperation = FlaskNavOperation(fluxLock: fluxLock, name: substance.state.layerActive )
        
        if NavLayer.IsNav(substance.state.layerActive){
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.displayNavOperation {
                    completion()
                }
            })
            
        } else if NavLayer.IsModal(substance.state.layerActive){
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.displayModalOperation {
                    completion()
                }
            })
        } else if  NavLayer.IsTab(substance.state.layerActive){
            let index = NavLayer.TabIndex(substance.state.layerActive)
            
            performOperationFor(navOperation: navOperation, withCompletion: {[weak self] completion in
                self?.displayTabOperation(index) {
                    completion()
                }
            })
            
        }
        
        
        
    }
    
}
