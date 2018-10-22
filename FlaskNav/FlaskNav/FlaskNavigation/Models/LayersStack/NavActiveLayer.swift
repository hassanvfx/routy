//
//  NavActiveLayer.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavActiveLayer {
    public private(set) var active:String = NavLayer.NAV.rawValue
    public private(set) var modal:Bool = false
    
    public private(set) var activeCaptured:String?
    public private(set) var modalCaptured:Bool?
    
    public var onModalChange:()->Void = {}

    
    public func show(layer:String){
        
        if NavLayer.IsModal(layer) {
            showModal()
        } else{
            set(layer:layer)
            hideModal()
        }
        
    }
    
    public func showTab(_ layerName:String){
        assert(NavLayer.IsTab(layerName))
        set(layer: layerName)
    }
    
    public func showModal(){
        set(modal: true)
    }
    
    public func hideTabs(){
        set(layer: NavLayer.Nav())
        hideModal()
    }
    
    public func hideModal(){
        set(modal: false)
    }
    
    
    public func set(layer:String){
        active = layer
    }
    
    public func set(modal:Bool){
        if self.modal != modal {
            self.modal = modal
            onModalChange()
        }
    }
    
    

    func capture(){
        assert(activeCaptured == nil , "State already captured")
        activeCaptured = active
        modalCaptured = modal
    }
    
    func rollback(){
        assert(activeCaptured != nil , "State not captured")
        active = activeCaptured!
        modal = modalCaptured!
        activeCaptured = nil
        modalCaptured = nil
    }
    
    func commit(){
        assert(activeCaptured != nil , "State not captured")
        activeCaptured = nil
        modalCaptured = nil
    }
}
