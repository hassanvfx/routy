//
//  Nav+API.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask


extension FlaskNav: NavStackAPI{
    
    func disablePendingHideInteraction(){
        
        let layerName = NavLayer.IsTab(stackActive.active) ?  NavLayer.TabAny() : stackActive.active
        
        if let currentAnimator = getActiveLayerAnimator(for: layerName, withType: .Hide){
            currentAnimator.disableInteraction()
        }
        
    }
    
    func push(layer:String, controller:String , resourceId:String?, info:Any? = nil, animator: NavAnimatorClass? = nil, presentation: NavPresentationClass? = nil, completion:NavContextCompletion? = nil) {

        let finalizer:NavCompletion = { result in self.completeContextOperation(layer: layer, result: result, contextCompletion: completion) }
    
        compTransaction(for: layer){ [weak self] (layer) in
           
            guard let this = self else { return }
            
            this.disablePendingHideInteraction()
            this.stackActive.set(layer:layer)
        }
        
        navTransaction(for: layer, completion:finalizer){ (layer,stack) in
          
            
            let context = NavContext.manager.context(layer:layer, navigator:.Push, controller: controller, resourceId: resourceId, info: info, animator:animator)
            stack.push(context: context)
        }
        
      
    }
    
    func pop(layer:String, toController controller:String, resourceId:String?, info:Any?, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        let finalizer:NavCompletion = { result in self.completeContextOperation(layer: layer, result: result, contextCompletion: completion) }
        
        compTransaction(for: layer, completion:finalizer){ [weak self] (layer) in
            guard let this = self else { return }
            
            if !this.dismissEmptyModal(for: layer) {
                this.stackActive.set(layer:layer)
            }
        }
        
        navTransaction(for: layer){ (layer,stack) in
            let context =  NavContext.manager.context(layer:layer, navigator:.Pop, controller: controller, resourceId: resourceId, info: info, animator: animator)
            stack.pop(toContextRef: context)
        }
        
        
        
    }
    func popCurrent(layer:String, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
     
        let finalizer:NavCompletion = { result in self.completeContextOperation(layer: layer, result: result, contextCompletion: completion) }
        
        compTransaction(for: layer, completion:finalizer){ [weak self] (layer) in
            guard let this = self else { return }
            
            if !this.dismissEmptyModal(for: layer) {
                this.stackActive.set(layer:layer)
            }
        }
        
        navTransaction(for: layer){ (layer,stack) in
            stack.pop(withAnimator: animator)
        }
        
       
    }
    func popToRoot(layer:String, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
       
        let finalizer:NavCompletion = { result in self.completeContextOperation(layer: layer, result: result, contextCompletion: completion) }
        
        compTransaction(for: layer, completion:finalizer){ [weak self] (layer) in
            guard let this = self else { return }
            
            if !this.dismissEmptyModal(for: layer) {
                this.stackActive.set(layer:layer)
            }
        }
        
        navTransaction(for: layer){ (layer,stack) in
            stack.clear(withAnimator: animator)
        }
        
        
    }
    
}

extension FlaskNav{
    
    func show(layer:String, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        let finalizer:NavCompletion = { result in self.completeCompOperation(layer: layer, result: result, contextCompletion: completion) }
        
        compTransaction(for: layer, completion:finalizer){ [weak self] (layer) in
            guard let this = self else {
                return
            }
            let layerName = NavLayer.IsTab(layer) ?  NavLayer.TabAny() : layer
            
            this.setActiveLayerAnimator(animator, for: layerName, withType: .Show)
            this.setActiveLayerAnimator(animator, for: layerName, withType: .Hide)
            this.stackActive.set(layer:layer)
        }
    }
    
    func hide(layer:String, explicit:Bool = false, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        let finalizer:NavCompletion = { result in self.completeCompOperation(layer: layer, result: result, contextCompletion: completion) }
        
        compTransaction(for: layer, completion:finalizer){ [weak self] (layer) in
            guard let this = self else {
                return
            }
            
            let layerName = NavLayer.IsTab(layer) ?  NavLayer.TabAny() : layer
            let currentLayerName = NavLayer.IsTab(this.stackActive.active) ?  NavLayer.TabAny() : this.stackActive.active
            
            if currentLayerName != layerName {
                assert(!explicit,"can't hide a layer that is not shown (active)")
                return
            }
            
            this.setActiveLayerAnimator(animator, for: layerName, withType: .Hide)
            this.stackActive.unset()
        }
        
    }
    
    func tabIndex(from layer: String) -> Int {
        return tabsIndexMap[layer]!
    }

}

extension FlaskNav{
    func completeContextOperation(layer:String, result:Bool, contextCompletion:NavContextCompletion?){
        let stack = self.stack(forLayer: layer)
        contextCompletion?( stack.currentContext(), result)
  
    }
    func completeCompOperation(layer:String, result:Bool, contextCompletion:NavContextCompletion?){
        let context = NavContext(id: -1, layer: layer, navigator: .Root, controller: layer, resourceId: nil, info: nil)
        contextCompletion?( context, result)
    }
}

extension FlaskNav{

    func flushModalStack(){
        self.stack(forLayer: NavLayer.Modal()).clear()
    }
    
    func clearModal(for layer:String)->Bool{
        
        if !NavLayer.IsModal(self.stackActive.active) { return false}
        if !NavLayer.IsModal(layer) { return false}
        
        self.stackActive.unset()
        
        return true
        
    }
    func dismissEmptyModal(for layer:String)->Bool{
        
        if !NavLayer.IsModal(self.stackActive.active) { return false}
       
        let stack = self.stack(forLayer: NavLayer.Modal())
        if stack.isEmpty() {
            self.stackActive.unset()
            return true
        }
        return false
        
    }
}


extension FlaskNav{
    
    func stack(forLayer name:String)->NavStack{
        
        if let stack = stackLayers[name] {
            return stack
        }
        let newStack = NavStack(layer:name)
        stackLayers[name] = newStack
        return newStack
    }
  
    
}





