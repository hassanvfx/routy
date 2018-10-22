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
        case layerActive,layers,modal
    }
    
    var layers:FlaskDictRef = FlaskDictRef()
    var layerActive:String = ROOT_CONTROLLER
    var modal:Bool = false
}

enum NavMixers:SubstanceMixer{
    case Navigation
    case Composition
}

class NavigationSubstance: ReactiveSubstance<NavigationState,NavMixers>{
    
    override func defineMixers() {
        
        define(mix: .Composition){ (payload, react, abort) in
            let layer = payload!["layerActive"]  as! String
            let modal = payload!["modal"]  as! Bool
            assert(!NavLayer.IsModal(layer), "use `modal` property instead")
            
            self.prop.layerActive = layer
            self.prop.modal = modal
            react()
        }
        
        define(mix: .Navigation) { (payload, react, abort) in
            let layers = payload!["layers"]  as! [String:String]
            self.prop.layers = FlaskDictRef(layers as NSDictionary)
            react()
        }
        
    }
}
