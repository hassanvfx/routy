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
    
    static let MinTab = 0
    static let MaxTab = 9
    
    static func isValid(_ layerName:String)->Bool{
        if(IsNav(layerName)){
            return true
        }
        
        if(IsNav(layerName)){
            return true
        }
        
        if(IsTab(layerName)){
            let index = TabIndex(layerName)
            return index >= MinTab && index <= MaxTab
        }
        
        
        
        return false
    }
    
    static func LayerNav()->String {
        return "layers.\(Nav())"
    }
    
    static func LayerModal()->String {
        return "layers.\(Modal())"
    }
    
    static func LayerTab(_ index:Int)->String {
        return "layers.\(Tab(index))"
    }
    
    static func Nav()->String {
        return "nav"
    }
    
    
    static func Modal()->String {
        return "modal"
    }
    
    static func Tab(_ index:Int)->String {
        return "tab\(index)"
    }
    
    
    static func IsNav(_ layer:String)->Bool {
        let parts = layer.split(separator: ".")
        return parts.last == "nav"
    }
    
    static func IsTab(_ layer:String)->Bool {
        let parts = layer.split(separator: ".")
        return (parts.last?.starts(with: "tab"))!
    }
    
    static func IsModal(_ layer:String)->Bool {
        let parts = layer.split(separator: ".")
        return parts.last == "modal"
    }
    

    static func TabIndex(_ layer:String)->Int {
        assert(IsTab(layer),"Not a TAB layer")
        let parts = layer.split(separator: ".")
        let stringIndex = parts.last?.replacingOccurrences(of: "tab", with: "")
        let index = Int(stringIndex!)!
        assert( index >= MinTab && index <= MaxTab, "invalid index")
        return index
    }
    
    
    
}
