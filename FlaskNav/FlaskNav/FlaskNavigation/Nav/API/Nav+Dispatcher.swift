
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
    
    func dispatchFlux(with operation:FlaskOperation,_ completion:@escaping NavCompletion){

        print("-------------")
        print("dispatch start ")
        
        let finalizer:NavCompletion = { finallyCompleted in
            print("dispatch completed ")
            completion(finallyCompleted)
        }
        
        dispatchActiveLayer(){ [weak self] activeCompleted in
            self?.dispatchCurrentNavigation(){ layersCompleted in
                finalizer(activeCompleted && layersCompleted)
            }
        }
 
        
    }

    func dispatchActiveLayer(_ completion:@escaping NavCompletion){

        
        assert(NavLayer.isValid(stackActive.active),"invalid layer name")
        
        let payload:[String : Any] = [
            "layerActive":stackActive.active,
            ]
        let lock = Flask.lock(withMixer: NavMixers.LayerActive, payload: payload, autorelease: true)
        lock.onRelease = { (payload) in
            
            if let completed = payload as? Bool {
                 completion(completed)
                return
            }
            completion(true)
           
        }
        print("dispatch applyActiveLayer: \(payload)")
    }
    

    func dispatchCurrentNavigation(_ completion:@escaping NavCompletion){

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
            if let completed = payload as? Bool {
                completion(completed)
                return
            }
            completion(true)
        }
        
        print("dispatch applyCurrentLayers: \(payload)")
    }
}
