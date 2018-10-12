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

    func push(layer:String, batched:Bool = false, controller:String , resourceId:String?, info:Any? = nil, animator: NavAnimatorClass? = nil, presentation: NavPresentationClass? = nil, callback: NavContextCallback?, completion:CompletionClosure? = nil) {

        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
            let context = NavContext.manager.context(layer:layer, navigator:.Push, controller: controller, resourceId: resourceId, info: info, animator:animator, callback)
            self?.stackActive.set(layer:layer)
            stack.push(context: context)
        }
    }
    
    func pop(layer:String, batched:Bool = false, toController controller:String, resourceId:String?, info:Any?, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
            let context =  NavContext.manager.context(layer:layer, navigator:.Pop, controller: controller, resourceId: resourceId, info: info, animator: animator)
            self?.stackActive.set(layer:layer)
            stack.pop(toContextRef: context)
        }
    }
    func popCurrent(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
     
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
           
            stack.pop(withAnimator: animator)
            
            if(NavLayer.IsModal(layer) &&
                stack.currentNavigator == .Root){
                self?.stackActive.unset()
            }else{
                self?.stackActive.set(layer:layer)
            }
            
        }
    }
    func popToRoot(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
       
      
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
            stack.clear(withAnimator: animator)
            
            if(NavLayer.IsModal(layer)){
                self?.stackActive.unset()
            }else{
                self?.stackActive.set(layer:layer)
            }
        }
    }
    
    func show(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
        activeLayerTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer) in
            guard let this = self else {
                return
            }
            let layerName = NavLayer.IsTab(layer) ?  NavLayer.TabAny() : layer
            
            this.setActiveLayerAnimator(animator, for: layerName, withType: .Show)
            this.stackActive.set(layer:layer)
        }
    }
    
    func hide(layer:String, batched:Bool = false, explicit:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
        activeLayerTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer) in
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

    func flushModalStack(){
        self.stack(forLayer: NavLayer.Modal()).clear()
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





