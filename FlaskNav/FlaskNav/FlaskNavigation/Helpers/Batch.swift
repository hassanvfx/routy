//
//  Batch.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/23/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit



protocol NavAPIDelegate:AnyObject{
    func push(controller:String , resourceId:String?, info:CodableInfo?, batched:Bool)
    func pop(toController controller:String, resourceId:String?, info:CodableInfo?, batched:Bool)
    func popCurrentControler(batched:Bool)
    func popToRootController(batched:Bool)
}

class NavBatch<T:RawRepresentable> {
    
    weak var delegate:NavAPIDelegate?
    
    public init(delegate:NavAPIDelegate?){
        self.delegate = delegate
    }
    
    public func push(controller:T, resourceId:String? = nil, info:CodableInfo? = nil){
        delegate?.push(controller: controller.rawValue as! String, resourceId: resourceId, info: info, batched: true)
        
    }
    
    public func pop(controller:T, resourceId:String? = nil, info:CodableInfo? = nil){
        delegate?.pop(toController: controller.rawValue as! String, resourceId: resourceId, info: info, batched: true)
    }
    func popCurrentControler(){
        delegate?.popCurrentControler(batched: true)
    }
    func popToRootController(){
        delegate?.popToRootController(batched: true)
    }
    
}
