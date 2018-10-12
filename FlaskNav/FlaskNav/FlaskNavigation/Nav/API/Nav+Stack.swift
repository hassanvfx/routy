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
            let context = NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, animator:animator, callback)
            self?.stackActiveLayer.setActive(layer:layer)
            stack.push(context: context)
        }
    }
    
    func pop(layer:String, batched:Bool = false, toController controller:String, resourceId:String?, info:Any?, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
            let context =  NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, animator: animator)
            self?.stackActiveLayer.setActive(layer:layer)
            stack.pop(toContextRef: context)
        }
    }
    func popCurrent(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
     
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
           
            stack.pop(withAnimator: animator)
            
            if(NavLayer.IsModal(layer) &&
                stack.currentNavigator == .Root){
                self?.stackActiveLayer.restoreActive()
            }else{
                self?.stackActiveLayer.setActive(layer:layer)
            }
            
        }
    }
    func popToRoot(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
       
      
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
            stack.clear(withAnimator: animator)
            
            if(NavLayer.IsModal(layer)){
                self?.stackActiveLayer.restoreActive()
            }else{
                self?.stackActiveLayer.setActive(layer:layer)
            }
        }
    }
    
    func show(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
       activeLayerTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer) in
            //TODO: handle show nav or nav
            self?.stackActiveLayer.setActive(layer:layer)
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





