//
//  NavAnimationFactory.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public typealias NavAnimatorConstructor = ()->NavAnimatorClass

public enum NavAnimatorName:String{
    case Slide, Zoom
}

public class NavAnimators: NSObject {
    
    static let shared = NavAnimators()
    
    var registry:[String:NavAnimatorConstructor] = [:]
    
    override init(){
        super.init()
        register("slide"){  NavAnimatorSlide(style: .slideLeft,intensity: 1)}
        register("zoom"){  NavAnimatorZoom(style: .zoomIn,intensity: 0.2)}
    }
    
    public func register(_ name:String,constructor:@escaping NavAnimatorConstructor){
        registry[name] = constructor
    }
    
    func constructor(named name:NavAnimatorName)->NavAnimatorConstructor?{
        return registry[name.rawValue]
    }
    
    public func constructor(registeredAs name:String)->NavAnimatorConstructor?{
        return registry[name]
    }

    func animator(from aJsonString:String?) -> NavAnimatorClass{
       
        guard aJsonString != nil else {
            return NavAnimatorZoom(style: .zoomIn, intensity: 0.2)
        }
        
        let jsonString = aJsonString!
        
        let params = NavSerializer.stringToDict(jsonString)
        let name = params["name"] as! String
        var instance:NavAnimatorClass?
        
        if let enumName = NavAnimatorName(rawValue: name){
            let constructor = self.constructor(named: enumName)
            instance = constructor!()
        }
        
        if let registeredConstructor = self.constructor(registeredAs: name){
            instance = registeredConstructor()
        }
        
        assert(instance != nil ,"name not registered")
        instance?.setParameters(jsonString)
        
        return instance!
    }
 
    func presentation(from:String?,for presented:UIViewController,from presenting:UIViewController) -> NavPresentationController{
        return NavPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
