//
//  Nav+Composition.swift
//  Roots
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

// MARK: - Exposes `compositon?` methods directly for convenience
extension Roots:NavCompositionAPI{

    typealias COMP_CONT_TYPE = CONT
    typealias COMP_TABS_TYPE = TABS
    typealias COMP_ACCS_TYPE = ACCS
    
    public var nav:NavInterface<CONT>{
        return (self.composition?.nav)!
    }

    public func tab(_ tab:TABS)->NavInterface<CONT>{
        return (composition?.tab(tab ))!
    }
    
    public func accesory(_ layer:Int=0)->NavInterface<ACCS>{
        return (composition?.accesory(layer))!
    }
}
