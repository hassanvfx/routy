
//
//  Nav+Dispatcher.swift
//  Roots
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension Roots{
 
    func applyContext(){
        
        var tabs:[String:String] = [:]
        var accesories:[String:String] = [:]
        
        for (layer,stack) in stackLayers {
            
            let oType = layer.split(separator: ".").first
            
            guard oType != nil else{
                continue
            }
            
            let type = oType!
            
            if type == StackLayer.TAB{
                tabs[layer] = stack.current().toString()
            }
            if type == StackLayer.ACCESORY{
                accesories[layer] = stack.current().toString()
            }
        }
        
        let nav = self.stack(forLayer: StackLayer.Main()).current()

        let payload:[String : Any] = [
            "nav":nav.toString(),
            "tabs":tabs,
            "accesories":accesories
        ]

        Flask.lock(withMixer: NavMixers.Controller, payload: payload )
    }
}
