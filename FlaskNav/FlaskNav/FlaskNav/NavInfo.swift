//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


public typealias NavConstructor = () -> UIViewController
public typealias RoutingMap = [String:NavConstructor]

open class  NavigationInfo<T:Hashable>: NavigationInfoConcrete{
    var router:RoutingMap = [:]
    
    override init() {
        super.init()
        configRouter()
    }
    
    override public  func constructorFor(_ path:String)->NavConstructor{
        
        if let constructor = router[path]{
            return constructor
        }
        fatalError("constuctor not defined")
    }
    
    
    func configRouter(){
    }
}


open class  NavigationInfoConcrete{
    open func  navBarHidden()->Bool{
        return true
    }
    open func  rootViewController<T:UIViewController>()->T{
        return UIViewController() as! T
    }
    
    public  func constructorFor(_ path:String)->NavConstructor{
        return {UIViewController()}
    }
    
}


