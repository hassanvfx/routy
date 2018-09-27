//
//  Substance.swift
//  Roots
//
//  Created by hassan uriostegui on 9/18/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

enum NavType:String,Codable{
    case NAV
    case TAB
}

struct NavigationState: State {
    
    enum prop : StateProp{
        case currentController,navType
    }
    var navType:NavType = .NAV
    var currentController = ROOT_CONTROLLER
    var currentTab = 0
    var accesories:[String:String]? = nil
}

enum NavMixers:SubstanceMixer{
    case Controller
    case NavType
    case TabNav
    case Accesory
}

class NavigationSubstance: ReactiveSubstance<NavigationState,NavMixers>{
    
    override func defineMixers() {
        define(mix: .Controller) { (payload, react, abort) in
            let context = payload!["nav"]  as! String
            self.prop.currentController = context
            react()
        }
        
        define(mix: .NavType) { (payload, react, abort) in
            
            let style = payload!["style"] as? String
            let index = payload!["index"] as? Int
            
            self.prop.navType = .NAV
            if style == NavType.TAB.rawValue {
                self.prop.navType = .TAB
                if let index = index {
                    self.prop.currentTab = index
                }
            }
            react()
        }
        
        define(mix: .Accesory) { (payload, react, abort) in
            let map = payload!["accesory"] as? [String : String]
            self.prop.accesories = map
            react()
        }
    }
}
