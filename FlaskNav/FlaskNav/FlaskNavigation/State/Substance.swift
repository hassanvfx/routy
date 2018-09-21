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
        case currentController
    }
    var currentController = ROOT_CONTROLLER
    var currentAccesory:String? = nil
}

enum NavigationMixers:SubstanceMixer{
    case Controller
    case Accesory
}

class NavigationSubstance: ReactiveSubstance<NavigationState,NavigationMixers>{
    
    override func defineMixers() {
        define(mix: .Controller) { (payload, react, abort) in
            let context = payload!["context"]  as! String
            self.prop.currentController = context
            react()
        }
        
        define(mix: .Accesory) { (payload, react, abort) in
            let context = payload!["context"]  as? String
            self.prop.currentAccesory = context
            react()
        }
    }
}
