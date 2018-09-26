//
//  Substance.swift
//  Roots
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
    var accesories:[String:String]? = nil
}

enum NavMixers:SubstanceMixer{
    case Controller
    case Accesory
}

class NavigationSubstance: ReactiveSubstance<NavigationState,NavMixers>{
    
    override func defineMixers() {
        define(mix: .Controller) { (payload, react, abort) in
            let context = payload!["nav"]  as! String
            self.prop.currentController = context
            react()
        }
        
        define(mix: .Accesory) { (payload, react, abort) in
            let map = payload!["accesory"]
            self.prop.accesories = map as? [String : String]
            react()
        }
    }
}
