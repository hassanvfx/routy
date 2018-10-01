//
//  Navswift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/29/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum NavLayer:String,Codable{
    
    case NAV = "nav"
    
    case TAB0 = "tab0"
    case TAB1 = "tab1"
    case TAB2 = "tab2"
    case TAB3 = "tab3"
    case TAB4 = "tab4"
    case TAB5 = "tab5"
    case TAB6 = "tab6"
    case TAB7 = "tab7"
    case TAB8 = "tab8"
    case TAB9 = "tab9"
    
    case ACCESORY0 = "accesory0"
    case ACCESORY1 = "accesory1"
    case ACCESORY2 = "accesory2"
    case ACCESORY3 = "accesory3"
    case ACCESORY4 = "accesory4"
    case ACCESORY5 = "accesory5"
    case ACCESORY6 = "accesory6"
    case ACCESORY7 = "accesory7"
    case ACCESORY8 = "accesory8"
    case ACCESORY9 = "accesory9"
    
    static let RootLayerLevel = 0
    static let MaxLayerLevel = 9
    
    static func isValid(_ layerName:String)->Bool{
        if(IsNav(layerName)){
            return true
        }
        
        if(IsTab(layerName)){
            let index = TabIndex(layerName)
            return index >= RootLayerLevel && index <= MaxLayerLevel
        }
        
        if(IsAccesory(layerName)){
            let index = AccesoryIndex(layerName)
            return index >= NavLayer.RootLayerLevel && index <= NavLayer.MaxLayerLevel
        }
        
        return false
    }
    
    static func LayerNav()->String {
        return "layers.\(Nav())"
    }
    
    static func LayerTab(_ index:Int)->String {
        return "layers.\(Tab(index))"
    }
    
    static func LayerAccesory(_ index:Int)->String {
        return "layers.\(Accesory(index))"
    }
    
    static func Nav()->String {
        return "nav"
    }
    
    static func Tab(_ index:Int)->String {
        return "tab\(index)"
    }
    
    static func Accesory(_ index:Int)->String {
        return "accesory\(index)"
    }
    
    static func IsNav(_ layer:String)->Bool {
        let parts = layer.split(separator: ".")
        return parts.last == "nav"
    }
    
    static func IsTab(_ layer:String)->Bool {
        let parts = layer.split(separator: ".")
        return (parts.last?.starts(with: "tab"))!
    }
    
    static func IsAccesory(_ layer:String)->Bool {
        let parts = layer.split(separator: ".")
        return (parts.last?.starts(with: "accesory"))!
    }
    
    
    
    static func TabIndex(_ layer:String)->Int {
        assert(IsTab(layer),"Not a TAB layer")
        let parts = layer.split(separator: ".")
        let stringIndex = parts.last?.replacingOccurrences(of: "tab", with: "")
        let index = Int(stringIndex!)!
        assert( index >= RootLayerLevel && index <= MaxLayerLevel, "invalid index")
        return index
    }
    
    static func AccesoryIndex(_ layer:String)->Int {
        assert(IsAccesory(layer),"Not an Accesory layer")
        let parts = layer.split(separator: ".")
        let stringIndex = parts.last?.replacingOccurrences(of: "accesory", with: "")
        let index = Int(stringIndex!)!
        assert( index >= RootLayerLevel && index <= MaxLayerLevel, "invalid index")
        return index
    }
    
}
