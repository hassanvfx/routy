//
//  Batch.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/23/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class StackLayer {
    
    static func Main()->String{
        return "main"
    }
    static func Tab(_ name:String) -> String{
        return "tab.\(name)"
    }
    
    static func Accesory(_ layer:Int)->String{
        return "accesory.\(layer)"
    }
    
}


protocol StackDelegate:AnyObject{
    func push(layer:String, controller:String , resourceId:String?, info:CodableInfo?, batched:Bool)
    func pop(layer:String, toController controller:String, resourceId:String?, info:CodableInfo?, batched:Bool)
    func popCurrentControler(layer:String, batched:Bool)
    func popToRootController(layer:String, batched:Bool)
}


class NavComposition<CONT:RawRepresentable,TABS:RawRepresentable,ACCS:RawRepresentable> : NSObject{
    
    weak var delegate:StackDelegate?
    let batched:Bool
    
    public init( batch:Bool=false, delegate:StackDelegate? ){
        self.delegate = delegate
        self.batched = batch
    }
    
    public var main:NavInterface<CONT>{
        return NavInterface<CONT>(batch:batched,layer: StackLayer.Main(), delegate: self)
    }
    
    public func tab(_ tab:TABS)->NavInterface<TABS>{
        let tabString = tab.rawValue as! String
        return NavInterface<TABS>(batch:batched, layer: StackLayer.Tab(tabString), delegate: self)
    }
    
    public func accesory(_ layer:Int=0)->NavInterface<ACCS>{
        return NavInterface<ACCS>(batch:batched,layer: StackLayer.Accesory(layer), delegate: self)
    }
    
}

extension NavComposition:StackDelegate{
    func push(layer: String, controller: String, resourceId: String?, info: CodableInfo?, batched: Bool) {
        self.delegate?.push(layer: layer, controller: controller, resourceId: resourceId, info: info, batched: batched)
    }
    
    func pop(layer: String, toController controller: String, resourceId: String?, info: CodableInfo?, batched: Bool) {
        self.delegate?.push(layer: layer, controller: controller, resourceId: resourceId, info: info, batched: batched)
    }
    
    func popCurrentControler(layer: String, batched: Bool) {
        self.delegate?.popCurrentControler(layer: layer, batched: batched)
    }
    
    func popToRootController(layer: String, batched: Bool) {
        self.delegate?.popToRootController(layer: layer, batched: batched)
    }
    
    
}

class NavInterface<T:RawRepresentable> {
    
    weak var delegate:StackDelegate?
    let layer:String
    let batched:Bool
    
   
    public init( batch:Bool=false, layer:String, delegate:StackDelegate? ){
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
    func popCurrentControler(){
        delegate?.popCurrentControler(layer:layer,batched: batched)
    }
    func popToRootController(){
        delegate?.popToRootController(layer:layer,batched: batched)
    }
    
}
