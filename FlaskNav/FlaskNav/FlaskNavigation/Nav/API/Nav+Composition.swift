//
//  Nav+Composition.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

// MARK: - Exposes `compositon?` methods directly for convenience
extension FlaskNav:NavCompositionAPI{
  
    typealias COMP_CONT_TYPE = CONT
    typealias COMP_TABS_TYPE = TABS
    typealias COMP_MODS_TYPE = MODS
    
    public var nav:NavInterface<CONT>{
        return (composition?.nav)!
    }
    
    public var modal:NavInterfaceModal<MODS>{
        return (composition?.modal)!
    }
    
    public var tab:NavInterfaceTabAny<CONT>{
        return (composition?.tabs)!
    }

    public func tab(_ tab:TABS)->NavInterface<CONT>{
        return (composition?.tab(tab ))!
    }
    
    
    
}
