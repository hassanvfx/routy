
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
    
    func applyContext(with operation:FlaskOperation){
        applyActiveLayer()
        applyCurrentLayers()
        
    }
    func applyActiveLayer(){
        
        assert(NavLayer.isValid(activeLayer()),"invalid layer name")
        
        let payload:[String : Any] = [
            "layerActive":activeLayer(),
            ]
        Flask.lock(withMixer: NavMixers.LayerActive, payload: payload )
    }
    
    func applyCurrentLayers(){
        var layers:[String:String] = [:]
        
        for (layer,stack) in stackLayers {
            assert(NavLayer.isValid(layer),"invalid layer name")
            layers[layer] = stack.currentContextHash()
        }
        
        let payload:[String : Any] = [
            "layers":layers,
            ]
        
        Flask.lock(withMixer: NavMixers.Layers, payload: payload )
    }
}
