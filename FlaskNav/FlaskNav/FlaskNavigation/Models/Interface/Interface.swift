//
//  Interface.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

protocol NavStackAPI:AnyObject{

    func push(layer:String, controller:String , resourceId:String?, info:Any?, animator:NavAnimatorClass?, presentation:NavPresentationClass?, completion:NavContextCompletion?)
    func pop(layer:String, toController controller:String, resourceId:String?, info:Any?, animator:NavAnimatorClass?, completion:NavContextCompletion?)
    func popCurrent(layer:String, animator:NavAnimatorClass?, completion:NavContextCompletion?)
    func popToRoot(layer:String, animator:NavAnimatorClass?, completion:NavContextCompletion?)
    func show(layer:String, animator:NavAnimatorClass?, completion:NavContextCompletion?)
    func hide(layer:String, explicit:Bool, animator:NavAnimatorClass?, completion:NavContextCompletion?)
    func tabIndex(from layer: String) -> Int
}

public class NavInterfaceAbstract<T:RawRepresentable> {
    
    weak var delegate:NavStackAPI?
    let layer:String
    
    init( layer:String, delegate:NavStackAPI? ){
        self.layer = layer
        self.delegate = delegate
    }
}

public class NavInterfaceCommon<T:RawRepresentable> : NavInterfaceAbstract<T> {

    public func push(controller:T, resourceId:String? = nil, info:Any? = nil, animator:NavAnimatorClass? = nil, presentation:NavPresentationClass? = nil, completion:NavContextCompletion? = nil){
        delegate?.push(layer:layer, controller: controller.rawValue as! String, resourceId: resourceId, info: info, animator: animator, presentation: presentation, completion: completion)
    }
    
    public func pop(toController controller:T, resourceId:String? = nil, info:Any? = nil, animator:NavAnimatorClass? = nil, completion:NavContextCompletion? = nil  ){
        delegate?.pop(layer:layer, toController: controller.rawValue as! String, resourceId: resourceId, info: info, animator:animator, completion: completion)
    }
    public func popCurrent(animator:NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        delegate?.popCurrent(layer:layer, animator:animator, completion: completion)
    }
   
}

public class NavInterface<T:RawRepresentable>: NavInterfaceCommon<T> {
    
    public func popToRoot(animator:NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        delegate?.popToRoot(layer:layer, animator:animator, completion: completion)
    }
    public func show(animator:NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        delegate?.show(layer:layer, animator:animator, completion: completion)
    }
    
    
}

public class NavInterfaceModal<T:RawRepresentable>: NavInterfaceCommon<T> {
    public func dismiss(animator:NavAnimatorClass? = nil, completion:NavContextCompletion? = nil){
        delegate?.popToRoot(layer:layer, animator:animator, completion: completion)
    }
}

public class NavInterfaceTabAny<T:RawRepresentable>: NavInterfaceAbstract<T> {

    public func hide(animator:NavAnimatorClass? = nil, explicit:Bool = false, completion:NavContextCompletion? = nil){
        delegate?.hide(layer:layer, explicit: explicit, animator:animator, completion: completion)
    }
}
