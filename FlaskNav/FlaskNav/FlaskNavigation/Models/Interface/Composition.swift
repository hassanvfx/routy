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
    
    var nav:NavInterface<COMP_CONT_TYPE>{get}
    var modal:NavInterfaceModal<COMP_MODS_TYPE>{get}
    func tab(_ tab:COMP_TABS_TYPE)->NavInterface<COMP_CONT_TYPE>
    func tab(_ tab:Int)->NavInterface<COMP_CONT_TYPE>
    func tabIndex(from layer:String) -> Int
}

extension NavCompositionAPI{
    
    public var nav:NavInterface<COMP_CONT_TYPE>{
        return NavInterface<COMP_CONT_TYPE>(layer: NavLayer.Nav(), delegate: self as? NavStackAPI)
    }
    
    public var modal:NavInterfaceModal<COMP_MODS_TYPE>{
        return NavInterfaceModal<COMP_MODS_TYPE>(layer: NavLayer.Modal(), delegate: self as? NavStackAPI)
    }
    
    public var tabAny:NavInterfaceTabAny<COMP_CONT_TYPE>{
        return NavInterfaceTabAny<COMP_CONT_TYPE>(layer: NavLayer.TabAny(), delegate: self as? NavStackAPI)
    }
    
    public func tab(_ tab:COMP_TABS_TYPE)->NavInterface<COMP_CONT_TYPE>{
        let tabString = tab.rawValue as! String
        let tabIndex = self.tabIndex(from: tabString)
        return self.tab(tabIndex)
    }
    
    func tab(_ tab:Int)->NavInterface<COMP_CONT_TYPE>{
       
        return NavInterface<COMP_CONT_TYPE>(layer: NavLayer.Tab(tab), delegate: self as? NavStackAPI)
    }
    
  
}

class NavComposition<TABS:RawRepresentable,CONT:RawRepresentable,MODS:RawRepresentable> : NSObject, NavCompositionAPI{
  
   
    typealias COMP_CONT_TYPE = CONT
    typealias COMP_TABS_TYPE = TABS
    typealias COMP_MODS_TYPE = MODS
    
    weak var compDelegate:NavStackAPI?
    
    public init( delegate:NavStackAPI? ){
        self.compDelegate = delegate
    }
    
}

extension NavComposition:NavStackAPI{

   
    func push(layer: String, controller: String, resourceId: String?, info: Any?, animator: NavAnimatorClass?, presentation: NavPresentationClass?, completion:CompletionClosure?) {
        self.compDelegate?.push(layer: layer, controller: controller, resourceId: resourceId, info: info, animator: animator, presentation: presentation, completion: completion)
    }
    
    func pop(layer: String, toController controller: String, resourceId: String?, info: Any?, animator: NavAnimatorClass?, completion:CompletionClosure?) {
        self.compDelegate?.pop(layer: layer, toController: controller, resourceId: resourceId, info: info, animator: animator, completion: completion)
    }
    
    func popCurrent(layer: String, animator: NavAnimatorClass?, completion:CompletionClosure?) {
        self.compDelegate?.popCurrent(layer: layer, animator: animator, completion: completion)
    }
    
    func popToRoot(layer: String, animator: NavAnimatorClass?, completion:CompletionClosure?) {
        self.compDelegate?.popToRoot(layer: layer, animator: animator, completion: completion)
    }
    
    func show (layer: String, animator: NavAnimatorClass?, completion:CompletionClosure?) {
        self.compDelegate?.show(layer: layer, animator: animator, completion: completion)
    }
    
    func hide(layer: String, explicit: Bool, animator: NavAnimatorClass?, completion: CompletionClosure?) {
        self.compDelegate?.hide(layer: layer, explicit:explicit, animator: animator, completion: completion)
    }
   
    func tabIndex(from layer: String) -> Int {
        return (self.compDelegate?.tabIndex(from: layer))!
    }
    
    
}
