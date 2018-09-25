//
//  StackLayers.swift
//  
//
//  Created by hassan uriostegui on 9/24/18.
//

import UIKit

class StackLayer {
    
    static func Main()->String{
        return "main"
    }
    static func Tab(_ name:String) -> String{
        return "tab.\(name)"
    }
    
    static func Accesory(_ layer:Int)->String{
        return "accesory.\(layer)"
    }
    
}

