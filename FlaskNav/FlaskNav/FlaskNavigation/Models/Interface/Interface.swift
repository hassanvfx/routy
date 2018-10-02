//
//  Interface.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

protocol NavStackAPI:AnyObject{
    func push(layer:String, batched:Bool, controller:String , resourceId:String?, info:Any?, callback:NavContextCallback?)
    func pop(layer:String, batched:Bool, toController controller:String, resourceId:String?, info:Any?)
    func popCurrent(layer:String, batched:Bool)
    func popToRoot(layer:String, batched:Bool)
    func show(layer:String, batched:Bool)
    func tabIndex(from layer: String) -> Int
}


public class NavInterface<T:RawRepresentable> {
    
    weak var delegate:NavStackAPI?
    let layer:String
    let batched:Bool
    
    init( batch:Bool=false, layer:String, delegate:NavStackAPI? ){
        self.layer = layer
        self.delegate = delegate
        self.batched = batch
    }
    
    public func push(controller:T, resourceId:String? = nil, info:Any? = nil, callback:NavContextCallback? = nil){
        delegate?.push(layer:layer, batched: batched, controller: controller.rawValue as! String, resourceId: resourceId, info: info, callback: callback)
    }
    
    public func pop(controller:T, resourceId:String? = nil, info:Any? = nil){
        delegate?.pop(layer:layer, batched: batched,toController: controller.rawValue as! String, resourceId: resourceId, info: info)
    }
    public func popCurrent(){
        delegate?.popCurrent(layer:layer,batched: batched)
    }
    public func popToRoot(){
        delegate?.popToRoot(layer:layer,batched: batched)
    }
    public func show(){
        delegate?.show(layer:layer,batched: batched)
    }
    
}
