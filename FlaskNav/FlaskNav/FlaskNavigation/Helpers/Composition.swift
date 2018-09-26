//
//  Composition.swift
//  Roots
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

/// This protocol is shared with the nav `Roots` object to facilitate accesing this defintion as a direct shorthand
protocol NavCompositionAPI:AnyObject{
    
    associatedtype COMP_CONT_TYPE:RawRepresentable
    associatedtype COMP_TABS_TYPE:RawRepresentable
    associatedtype COMP_ACCS_TYPE:RawRepresentable
    
    var compDelegate:NavStackAPI? {get}
    var compBatched:Bool{get}
    
    var nav:NavInterface<COMP_CONT_TYPE>{get}
    func tab(_ tab:COMP_TABS_TYPE)->NavInterface<COMP_CONT_TYPE>
    func accesory(_ layer:Int)->NavInterface<COMP_ACCS_TYPE>
}

extension NavCompositionAPI{
    
    public var nav:NavInterface<COMP_CONT_TYPE>{
        return NavInterface<COMP_CONT_TYPE>(batch:compBatched,layer: StackLayer.Main(), delegate: self as? NavStackAPI)
    }
    
    public func tab(_ tab:COMP_TABS_TYPE)->NavInterface<COMP_CONT_TYPE>{
        let tabString = tab.rawValue as! String
        return NavInterface<COMP_CONT_TYPE>(batch:compBatched, layer: StackLayer.Tab(tabString), delegate: self as? NavStackAPI)
    }
    
    public func accesory(_ layer:Int=0)->NavInterface<COMP_ACCS_TYPE>{
        return NavInterface<COMP_ACCS_TYPE>(batch:compBatched,layer: StackLayer.Accesory(layer), delegate: self as? NavStackAPI)
    }
}

class NavComposition<TABS:RawRepresentable,CONT:RawRepresentable,ACCS:RawRepresentable> : NSObject, NavCompositionAPI{
   
    typealias COMP_CONT_TYPE = CONT
    typealias COMP_TABS_TYPE = TABS
    typealias COMP_ACCS_TYPE = ACCS
    
    weak var compDelegate:NavStackAPI?
    let compBatched:Bool
    
    public init( batch:Bool=false, delegate:NavStackAPI? ){
        self.compDelegate = delegate
        self.compBatched = batch
    }
    
}

// MARK: - The composition intercepts the StackInterface and injects the boolean `batched` context. This is a requirement for the transactions
extension NavComposition:NavStackAPI{
    func push(layer: String, controller: String, resourceId: String?, info: CodableInfo?, batched: Bool) {
        self.compDelegate?.push(layer: layer, controller: controller, resourceId: resourceId, info: info, batched: compBatched)
    }
    
    func pop(layer: String, toController controller: String, resourceId: String?, info: CodableInfo?, batched: Bool) {
        self.compDelegate?.push(layer: layer, controller: controller, resourceId: resourceId, info: info, batched: compBatched)
    }
    
    func popCurrentControler(layer: String, batched: Bool) {
        self.compDelegate?.popCurrentControler(layer: layer, batched: compBatched)
    }
    
    func popToRootController(layer: String, batched: Bool) {
        self.compDelegate?.popToRootController(layer: layer, batched: compBatched)
    }
    
    
}
