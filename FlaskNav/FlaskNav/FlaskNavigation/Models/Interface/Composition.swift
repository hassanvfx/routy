//
//  Composition.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

/// This protocol is shared with the nav `FlaskNav` object to facilitate accesing this defintion as a direct shorthand
protocol NavCompositionAPI:AnyObject{
    
    associatedtype COMP_CONT_TYPE:RawRepresentable
    associatedtype COMP_TABS_TYPE:RawRepresentable
    associatedtype COMP_MODS_TYPE:RawRepresentable
    
    var compDelegate:NavStackAPI? {get}
    var compBatched:Bool{get}
    
    var nav:NavInterface<COMP_CONT_TYPE>{get}
    var modal:NavInterfaceModal<COMP_MODS_TYPE>{get}
    func tab(_ tab:COMP_TABS_TYPE)->NavInterface<COMP_CONT_TYPE>
    func tab(_ tab:Int)->NavInterface<COMP_CONT_TYPE>
    func tabIndex(from layer:String) -> Int
}

extension NavCompositionAPI{
    
    public var nav:NavInterface<COMP_CONT_TYPE>{
        return NavInterface<COMP_CONT_TYPE>(batch:compBatched,layer: NavLayer.Nav(), delegate: self as? NavStackAPI)
    }
    
    public var modal:NavInterfaceModal<COMP_MODS_TYPE>{
        return NavInterfaceModal<COMP_MODS_TYPE>(batch:compBatched,layer: NavLayer.Modal(), delegate: self as? NavStackAPI)
    }
    
    public func tab(_ tab:COMP_TABS_TYPE)->NavInterface<COMP_CONT_TYPE>{
        let tabString = tab.rawValue as! String
        let tabIndex = self.tabIndex(from: tabString)
        return self.tab(tabIndex)
    }
    
    func tab(_ tab:Int)->NavInterface<COMP_CONT_TYPE>{
       
        return NavInterface<COMP_CONT_TYPE>(batch:compBatched, layer: NavLayer.Tab(tab), delegate: self as? NavStackAPI)
    }
    
  
}

class NavComposition<TABS:RawRepresentable,CONT:RawRepresentable,MODS:RawRepresentable> : NSObject, NavCompositionAPI{
  
   
    typealias COMP_CONT_TYPE = CONT
    typealias COMP_TABS_TYPE = TABS
    typealias COMP_MODS_TYPE = MODS
    
    weak var compDelegate:NavStackAPI?
    let compBatched:Bool
    
    public init( batch:Bool=false, delegate:NavStackAPI? ){
        self.compDelegate = delegate
        self.compBatched = batch
    }
    
}

// MARK: - The composition intercepts the StackInterface and injects the boolean `batched` context. This is a requirement for the transactions
extension NavComposition:NavStackAPI{
    func push(layer: String, batched: Bool, controller: String, resourceId: String?, info: Any?, animator: NavAnimatorClass?, presentation: NavPresentationClass?, callback: NavContextCallback?, completion:CompletionClosure?) {
        self.compDelegate?.push(layer: layer, batched: compBatched, controller: controller, resourceId: resourceId, info: info, animator: animator, presentation: presentation, callback: callback, completion: completion)
    }
    
    func pop(layer: String, batched: Bool, toController controller: String, resourceId: String?, info: Any?, completion:CompletionClosure?) {
        self.compDelegate?.pop(layer: layer, batched: compBatched, toController: controller, resourceId: resourceId, info: info, completion: completion)
    }
    
    func popCurrent(layer: String, batched: Bool, completion:CompletionClosure?) {
        self.compDelegate?.popCurrent(layer: layer, batched: compBatched, completion: completion)
    }
    
    func popToRoot(layer: String, batched: Bool, completion:CompletionClosure?) {
        self.compDelegate?.popToRoot(layer: layer, batched: compBatched, completion: completion)
    }
    
    func show (layer: String, batched: Bool, completion:CompletionClosure?) {
        self.compDelegate?.show (layer: layer, batched: compBatched, completion: completion)
    }
   
    func tabIndex(from layer: String) -> Int {
        return (self.compDelegate?.tabIndex(from: layer))!
    }
    
    
}
