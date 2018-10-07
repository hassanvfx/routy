
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
    
    func dispatchStack(with operation:FlaskOperation){
        print("dispatch start")
        applyActiveLayer(){ [weak self] in
            self?.applyCurrentLayers(){
                print("dispatch completed")
                operation.complete()
            }
        }
        
    }
    func applyActiveLayer(_ completion:@escaping ()->Void){
        
        assert(NavLayer.isValid(activeLayer()),"invalid layer name")
        
        let payload:[String : Any] = [
            "layerActive":activeLayer(),
            ]
        let lock = Flask.lock(withMixer: NavMixers.LayerActive, payload: payload, autorelease: true)
        lock.onRelease = { (payload) in
            completion()
        }
        print("dispatch applyActiveLayer: \(payload)")
    }
    
    func applyCurrentLayers(_ completion:@escaping ()->Void){
        var layers:[String:String] = [:]
        
        for (layer,stack) in stackLayers {
            assert(NavLayer.isValid(layer),"invalid layer name")
            layers[layer] = stack.currentContextHash()
        }
        
        let payload:[String : Any] = [
            "layers":layers,
            ]
        
        let lock = Flask.lock(withMixer: NavMixers.Layers, payload: payload, autorelease: true )
        lock.onRelease = { (payload) in
            completion()
        }
        
        print("dispatch applyCurrentLayers: \(payload)")
    }
}
