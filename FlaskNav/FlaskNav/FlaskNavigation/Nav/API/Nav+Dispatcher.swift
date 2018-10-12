
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
    
    func dispatchStack(with operation:FlaskOperation,_ completion:@escaping CompletionClosure){
        print("dispatch start")
        applyActiveLayer(){ [weak self] activeCompleted in
            self?.applyCurrentLayers(){ layersCompleted in
                print("dispatch completed")
                completion(layersCompleted)
                operation.complete()
            }
        }
        
    }
    func applyActiveLayer(_ completion:@escaping CompletionClosure){
        
        assert(NavLayer.isValid(activeLayer()),"invalid layer name")
        
        let payload:[String : Any] = [
            "layerActive":activeLayer(),
            ]
        let lock = Flask.lock(withMixer: NavMixers.LayerActive, payload: payload, autorelease: true)
        lock.onRelease = { (payload) in
            let info = (payload as? Bool) ?? true
            completion(info)
        }
        print("dispatch applyActiveLayer: \(payload)")
    }
    
    func applyCurrentLayers(_ completion:@escaping CompletionClosure){
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
            let info = (payload as? Bool) ?? true
            completion(info)
        }
        
        print("dispatch applyCurrentLayers: \(payload)")
    }
}
