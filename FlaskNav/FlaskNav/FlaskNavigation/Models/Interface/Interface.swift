//
//  Interface.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

protocol NavStackAPI:AnyObject{
    func push(layer:String, batched:Bool, controller:String , resourceId:String?, info:Any?, animator:NavAnimatorClass?, presentation:NavPresentationClass?, callback:NavContextCallback?, completion:CompletionClosure?)
    func pop(layer:String, batched:Bool, toController controller:String, resourceId:String?, info:Any?, completion:CompletionClosure?)
    func popCurrent(layer:String, batched:Bool, completion:CompletionClosure?)
    func popToRoot(layer:String, batched:Bool, completion:CompletionClosure?)
    func show(layer:String, batched:Bool, completion:CompletionClosure?)
    func tabIndex(from layer: String) -> Int
}

public class NavInterfaceCommon<T:RawRepresentable> {

    weak var delegate:NavStackAPI?
    let layer:String
    let batched:Bool
    
    init( batch:Bool=false, layer:String, delegate:NavStackAPI? ){
        self.layer = layer
        self.delegate = delegate
        self.batched = batch
    }
    
    public func push(controller:T, resourceId:String? = nil, info:Any? = nil, animator:NavAnimatorClass? = nil, presentation:NavPresentationClass? = nil, callback:NavContextCallback? = nil, completion:CompletionClosure? = nil){
        delegate?.push(layer:layer, batched: batched, controller: controller.rawValue as! String, resourceId: resourceId, info: info, animator: animator, presentation: presentation, callback: callback, completion: completion)
    }
    
    public func pop(controller:T, resourceId:String? = nil, info:Any? = nil, completion:CompletionClosure? = nil  ){
        delegate?.pop(layer:layer, batched: batched,toController: controller.rawValue as! String, resourceId: resourceId, info: info, completion: completion)
    }
    public func popCurrent(completion:CompletionClosure? = nil){
        delegate?.popCurrent(layer:layer,batched: batched, completion: completion)
    }
   
}

public class NavInterface<T:RawRepresentable>: NavInterfaceCommon<T> {
    
    public func popToRoot(completion:CompletionClosure? = nil){
        delegate?.popToRoot(layer:layer,batched: batched, completion: completion)
    }
    public func show(completion:CompletionClosure? = nil){
        delegate?.show(layer:layer, batched: batched, completion: completion)
    }
    
}

public class NavInterfaceModal<T:RawRepresentable>: NavInterfaceCommon<T> {
    
    public func dismiss(completion:CompletionClosure? = nil){
        delegate?.popToRoot(layer:layer,batched: batched, completion: completion)
    }
    
}
