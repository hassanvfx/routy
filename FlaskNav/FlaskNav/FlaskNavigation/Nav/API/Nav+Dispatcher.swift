
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
    
    func dispatchFlux(nav:Bool, with operation:FlaskOperation,_ completion:@escaping NavCompletion){

      
        
        let finalizer:NavCompletion = { finallyCompleted in
            completion(finallyCompleted)
        }
        
        if nav{
            print("dispatch FLUX nav")
            dispatchNavigation(){ layersCompleted in
                finalizer(layersCompleted)
            }
        } else{
            print("dispatch FLUX comp")
            dispatchComposition(){  activeCompleted in
                finalizer(activeCompleted)
            }
        }
 
        
    }
    
    

    func dispatchComposition(_ completion:@escaping NavCompletion){

        
        assert(NavLayer.isValid(stackActive.active),"invalid layer name")
        
        let payload:[String : Any] = [
            "layerActive":stackActive.active,
            "modal":stackActive.modal
            ]
        
        
        let lock = Flask.lock(withMixer: NavMixers.Composition, payload: payload, autorelease: true)
        lock.onRelease = { (payload) in
            
            if let completed = payload as? Bool {
                 completion(completed)
                return
            }
            completion(true)
           
        }
        print("dispatch composition: \(payload)")
    }
    

    func dispatchNavigation(_ completion:@escaping NavCompletion){

        var layers:[String:String] = [:]
        
        for (layer,stack) in stackLayers {
            assert(NavLayer.isValid(layer),"invalid layer name")
            layers[layer] = stack.currentContextHash()
        }
        
        let payload:[String : Any] = [
            "layers":layers,
            ]
        
        let lock = Flask.lock(withMixer: NavMixers.Navigation, payload: payload, autorelease: true )
        lock.onRelease = { (payload) in
            if let completed = payload as? Bool {
                completion(completed)
                return
            }
            completion(true)
        }
        
        print("dispatch navigation: \(payload)")
    }
}
