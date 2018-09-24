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
}

class NavBatch<T:RawRepresentable> {
    
    weak var delegate:NavAPIDelegate?
    
    public init(delegate:NavAPIDelegate?){
        self.delegate = delegate
    }
    
    public func push( controller:T, info:CodableInfo? = nil){
        delegate?.push(controller: controller.rawValue as! String, resourceId: nil, info: info, batched: true)
    }
    
    public func push(controller:T, resourceId:String?, info:CodableInfo? = nil){
        delegate?.push(controller: controller.rawValue as! String, resourceId: resourceId, info: info, batched: true)
        
    }
}
