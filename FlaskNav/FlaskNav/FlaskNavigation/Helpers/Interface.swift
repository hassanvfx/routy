//
//  Interface.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

protocol NavStackAPI:AnyObject{
    func push(layer:String, controller:String , resourceId:String?, info:CodableInfo?, batched:Bool)
    func pop(layer:String, toController controller:String, resourceId:String?, info:CodableInfo?, batched:Bool)
    func popCurrentControler(layer:String, batched:Bool)
    func popToRootController(layer:String, batched:Bool)
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
    
    public func push(controller:T, resourceId:String? = nil, info:CodableInfo? = nil){
        delegate?.push(layer:layer, controller: controller.rawValue as! String, resourceId: resourceId, info: info, batched: batched)
    }
    
    public func pop(controller:T, resourceId:String? = nil, info:CodableInfo? = nil){
        delegate?.pop(layer:layer,toController: controller.rawValue as! String, resourceId: resourceId, info: info, batched: batched)
    }
    public func popCurrentControler(){
        delegate?.popCurrentControler(layer:layer,batched: batched)
    }
    public func popToRootController(){
        delegate?.popToRootController(layer:layer,batched: batched)
    }
    
}
