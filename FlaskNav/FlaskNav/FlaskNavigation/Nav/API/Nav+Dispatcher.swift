
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
    
    func dispatchFlux(with operation:FlaskOperation,_ completion:@escaping CompletionClosure){

        print("-------------")
        print("dispatch start ")
        
        let finalizer:CompletionClosure = { finallyCompleted in
            print("dispatch completed ")
            completion(finallyCompleted)
            operation.complete()
        }
        
        dispatchActiveLayer(){ [weak self] activeCompleted in
            self?.dispatchCurrentNavigation(){ layersCompleted in
                finalizer(layersCompleted)
            }
        }
 
        
    }

    func dispatchActiveLayer(_ completion:@escaping CompletionClosure){

        
        assert(NavLayer.isValid(stackActive.active),"invalid layer name")
        
        let payload:[String : Any] = [
            "layerActive":stackActive.active,
            ]
        let lock = Flask.lock(withMixer: NavMixers.LayerActive, payload: payload, autorelease: true)
        lock.onRelease = { (payload) in
            let info = (payload as? Bool) ?? true
            completion(info)
        }
        print("dispatch applyActiveLayer: \(payload)")
    }
    

    func dispatchCurrentNavigation(_ completion:@escaping CompletionClosure){

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
