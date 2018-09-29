//
//  Substance.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/18/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask



struct NavigationState: State {
    
    enum prop : StateProp{
        case layerActive
    }
    
    var layers:FlaskDictRef = FlaskDictRef()
    var layerActive:String = ROOT_CONTROLLER
}

enum NavMixers:SubstanceMixer{
    case Layers
    case LayerActive
}

class NavigationSubstance: ReactiveSubstance<NavigationState,NavMixers>{
    

    
    
    override func defineMixers() {
        
        define(mix: .LayerActive){ (payload, react, abort) in
            let layer = payload!["layerActive"]  as! String
            self.prop.layerActive = layer
            react()
        }
        
        define(mix: .Layers) { (payload, react, abort) in
            let layers = payload!["layers"]  as! [String:String]
            self.prop.layers = FlaskDictRef(layers as NSDictionary)
            react()
        }
    }
}
