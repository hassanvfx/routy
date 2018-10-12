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
       flushModalStack()
        _layerInactive = _layerActive
        _layerActive = layer
    }
    
    func restoreInactiveLayer(){
        _layerActive = _layerInactive
    }
}
extension FlaskNav{
 
    func stackTransaction(for layer:String, batched:Bool,  completion:CompletionClosure?, action:@escaping (String,NavStack)->Void){
        
        
        var onCompletion:CompletionClosure? = { completed in
            let stack = self.stack(forLayer: layer)
            if completed {
                stack.commit()
            } else {
                stack.rollback()
            }
            if let userCompletion = completion {
                userCompletion(completed)
            }
        }
        
        if batched { onCompletion = nil }
        
        stackOperation(batched:batched, completion: onCompletion ) {
            let stack = self.stack(forLayer: layer)
            
            if !batched { stack.capture() }
            action(layer,stack)
        }
        
        
    }
}

extension FlaskNav: NavStackAPI{

    func push(layer:String, batched:Bool = false, controller:String , resourceId:String?, info:Any? = nil, animator: NavAnimatorClass? = nil, presentation: NavPresentationClass? = nil, callback: NavContextCallback?, completion:CompletionClosure? = nil) {
    
    
        stackTransaction(for: layer,batched: batched, completion:completion){ [weak self] (layer,stack) in
            let context = NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, animator:animator, callback)
            self?.setActive(layer:layer)
            stack.push(context: context)
        }
      

//        queueIntent(batched:batched, completion: completion ) { [weak self] in
//            guard let this = self else { return }
//            let context = NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, animator:animator, callback)
//            let stack = this.stack(forLayer: layer)
//            this.setActive(layer:layer)
//            stack.push(context: context)
//        }
    }
    
    func pop(layer:String, batched:Bool = false, toController controller:String, resourceId:String?, info:Any?, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
 
        stackOperation(batched:batched, completion: completion) { [weak self] in
            let context =  NavContext.manager.context(layer:layer, controller: controller, resourceId: resourceId, info: info, animator: animator)
            self?.setActive(layer:layer)
            self?.stack(forLayer: layer).pop(toContextRef: context)
        }
    }
    func popCurrent(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
     
        stackOperation(batched:batched, completion: completion) { [weak self] in
           
            self?.stack(forLayer: layer).pop(withAnimator: animator)
            
            if(NavLayer.IsModal(layer) &&
                self?.stack(forLayer: layer).currentNavigator == .Root){
                self?.restoreInactiveLayer()
            }else{
                self?.setActive(layer:layer)
            }
            
        }
    }
    func popToRoot(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
       
      
        stackOperation(batched:batched, completion: completion) { [weak self] in
            self?.stack(forLayer: layer).clear(withAnimator: animator)
            
            if(NavLayer.IsModal(layer)){
                self?.restoreInactiveLayer()
            }else{
                self?.setActive(layer:layer)
            }
        }
    }
    
    func show(layer:String, batched:Bool = false, animator: NavAnimatorClass? = nil, completion:CompletionClosure? = nil){
        
       
        stackOperation(batched:batched, completion: completion) { [weak self] in
            //TODO: handle show nav or nav
            self?.setActive(layer:layer)
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






