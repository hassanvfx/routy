//
//  Nav+API.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav{
 
    func stack(forLayer name:String)->NavStack{
        
        if let stack = stackLayers[name] {
            return stack
        }
        let newStack = NavStack(layer:name)
        stackLayers[name] = newStack
        return newStack
    }
    
    func activeLayer()->String{
        return _layerActive
    }
    
    func setActive(layer:String){
        if(_layerActive == layer){return}
        _layerInactive = _layerActive
        _layerActive = layer
    }
    
    func restoreInactiveLayer(){
        _layerActive = _layerInactive
    }
}


extension FlaskNav: NavStackAPI{
    
    func push(layer:String, batched:Bool = false, controller:String , resourceId:String?, info:Any? = nil, callback:NavContextCallback? = nil){
        queueIntent(batched:batched) { [weak self] in
            let context = NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, callback)
            self?.setActive(layer:layer)
            self?.stack(forLayer: layer).push(context: context)
        }
    }
    
    func pop(layer:String, batched:Bool = false, toController controller:String, resourceId:String?, info:Any?){
        queueIntent(batched:batched) { [weak self] in
            let context =  NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info)
            self?.setActive(layer:layer)
            self?.stack(forLayer: layer).pop(toContextRef: context)
        }
    }
    func popCurrent(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
           
            self?.stack(forLayer: layer).pop()
            
            if(NavLayer.IsModal(layer) &&
                self?.stack(forLayer: layer).currentNavigator == .Root){
                self?.restoreInactiveLayer()
            }else{
                self?.setActive(layer:layer)
            }
            
        }
    }
    func popToRoot(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            self?.stack(forLayer: layer).clear()
            
            if(NavLayer.IsModal(layer)){
                self?.restoreInactiveLayer()
            }else{
                self?.setActive(layer:layer)
            }
        }
    }
    
    func show(layer:String, batched:Bool = false){
        queueIntent(batched:batched) { [weak self] in
            //TODO: handle show nav or nav
            self?.setActive(layer:layer)
        }
    }
    
    
}






