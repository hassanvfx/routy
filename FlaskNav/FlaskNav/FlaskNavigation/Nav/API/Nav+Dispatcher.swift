
//
//  Nav+Dispatcher.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav{
    
    func applyContext(){
        applyActiveLayer()
        applyCurrentLayers()
        
    }
    func applyActiveLayer(){
        let payload:[String : Any] = [
            "layerActive":stackActive,
            ]
        Flask.lock(withMixer: NavMixers.LayerActive, payload: payload )
    }
    
    func applyCurrentLayers(){
        var layers:[String:String] = [:]
        
        for (layer,stack) in stackLayers {
            layers[layer] = stack.current().toString()
        }
        
        let payload:[String : Any] = [
            "layers":layers,
            ]
        
        Flask.lock(withMixer: NavMixers.Layers, payload: payload )
    }
}
