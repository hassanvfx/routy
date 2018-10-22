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
        
        let finalizer:NavCompletion = { result in self.completeNavOperation(layer: layer, result: result, contextCompletion: completion) }
        
        transaction(for: layer, completion: finalizer){ [weak self] transaction in
            guard let this = self else { return }
            
            this.comp(transaction: transaction){ (transaction) in
                this.disablePendingHideInteraction()
                this.stackActive.show(layer: transaction.layer)
            }
            
            this.nav(transaction: transaction){ (transaction) in
                let context = NavContext.manager.context(layer:transaction.layer, navigator:.Push, controller: controller, resourceId: resourceId, info: info, animator:animator)
                transaction.stack().push(context: context)
            }
            
            this.comp(transaction: transaction){ (transaction) in
                this.syncWithDisplay()
            }
        }
        
    }
    
    func pop(layer:String, toController controller:String, resourceId:String?, info:Any?, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        let finalizer:NavCompletion = { result in self.completeNavOperation(layer: layer, result: result, contextCompletion: completion) }
        
        transaction(for: layer, completion: finalizer){ [weak self] transaction in
            guard let this = self else { return }
            
            this.comp(transaction: transaction){ (transaction) in
                this.stackActive.show(layer: transaction.layer)
            }
            
            this.nav(transaction: transaction){ (transaction) in
                let context =  NavContext.manager.context(layer:transaction.layer, navigator:.Pop, controller: controller, resourceId: resourceId, info: info, animator: animator)
                transaction.stack().pop(toContextRef: context)
            }
            
            this.comp(transaction: transaction){ (transaction) in
                this.syncWithDisplay()
            }
        }
        
    }
    func popCurrent(layer:String, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        let finalizer:NavCompletion = { result in self.completeNavOperation(layer: layer, result: result, contextCompletion: completion) }
        
        transaction(for: layer, completion: finalizer){ [weak self] transaction in
            guard let this = self else { return }
            
            this.comp(transaction: transaction){ (transaction) in
                this.stackActive.show(layer: transaction.layer)
            }
            
            this.nav(transaction: transaction){ (transaction) in
                transaction.stack().pop(withAnimator: animator)
            }
            
            this.comp(transaction: transaction){ (transaction) in
                this.syncWithDisplay()
            }
        }
        
    }
    func popToRoot(layer:String, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        let finalizer:NavCompletion = { result in self.completeNavOperation(layer: layer, result: result, contextCompletion: completion) }
        
        transaction(for: layer, completion: finalizer){ [weak self] transaction in
            guard let this = self else { return }
            
            this.comp(transaction: transaction){  (transaction) in
                this.stackActive.show(layer: transaction.layer)
            }
            
            this.nav(transaction: transaction){  (transaction) in
                transaction.stack().clear(withAnimator: animator)
            }
            
            this.comp(transaction: transaction){  (transaction) in
                this.syncWithDisplay()
            }
        }
        
    }
    
}

extension FlaskNav{
    
    func show(layer:String, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        if NavLayer.IsNav(layer) {
            hide(layer: NavLayer.TabAny(), animator: animator, completion: completion)
            return
        }
        
        let finalizer:NavCompletion = { result in self.completeCompOperation(layer: layer, result: result, contextCompletion: completion) }
        
        transaction(for: layer, completion: finalizer){ [weak self] transaction in
            guard let this = self else { return }
           
            this.comp(transaction: transaction){  (transaction) in
               
                let layerName = NavLayer.IsTab(transaction.layer) ?  NavLayer.TabAny() : transaction.layer
                
                this.setActiveLayerAnimator(animator, for: layerName, withType: .Show)
                this.setActiveLayerAnimator(animator, for: layerName, withType: .Hide)
                
                if NavLayer.IsTab(layer) ||  NavLayer.IsTabAny(transaction.layer){
                    this.stackActive.showTab(transaction.layer)
                } else if NavLayer.IsModal(transaction.layer) {
                    this.stackActive.showModal()
                } else{
                    assert(false,"nav should never hide")
                }
                
            }
        }
    }
    
    func hide(layer:String, explicit:Bool = false, animator: NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        
        if NavLayer.IsNav(layer) {
            show(layer: NavLayer.TabAny(), animator: animator, completion: completion)
            return
        }
        
        let finalizer:NavCompletion = { result in self.completeCompOperation(layer: layer, result: result, contextCompletion: completion) }
        
        transaction(for: layer, completion: finalizer){ [weak self] transaction in
            guard let this = self else { return }
            
            this.comp(transaction: transaction){  (transaction) in
                
                let layerName = NavLayer.IsTab(transaction.layer) ?  NavLayer.TabAny() : transaction.layer
                let currentLayerName = NavLayer.IsTab(this.stackActive.active) ?  NavLayer.TabAny() : this.stackActive.active
                
                if currentLayerName != layerName {
                    assert(!explicit,"can't hide a layer that is not shown (active)")
                    return
                }
                
                this.setActiveLayerAnimator(animator, for: layerName, withType: .Hide)
                
                if NavLayer.IsTab(transaction.layer) ||  NavLayer.IsTabAny(transaction.layer){
                    this.stackActive.hideTabs()
                } else if NavLayer.IsModal(transaction.layer) {
                    this.stackActive.hideModal()
                } else{
                    assert(false,"nav should never hide")
                }
                
            }
        }
        
    }
    
    func tabIndex(from layer: String) -> Int {
        return tabsIndexMap[layer]!
    }
    
}

extension FlaskNav{
    func completeNavOperation(layer:String, result:Bool, contextCompletion:NavContextCompletion?){
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
    
    func syncWithDisplay(){
        syncModal()
        syncTabs()
        syncNavs()
    }
    
    func syncModal(){
        hideEmptyModal()
    }
    
    func syncTabs(){
        
    }
    
    func syncNavs(){
        
    }
    
    @discardableResult
    func hideEmptyModal()->Bool{
        
        if !NavLayer.IsModal(self.stackActive.active) { return false}
        
        let stack = self.stack(forLayer: NavLayer.Modal())
        if stack.isEmpty() {
            self.stackActive.hideModal()
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





