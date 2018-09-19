//
//  MyNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum MainControllers {
    case Home, Settings, Feed
}



class AppNav: NavigationInfo {
    
    var router: RoutingMap = [:]

    
    func  rootViewController<T:UIViewController>()->T{
        return ViewController() as! T
    }
    
    func setupRouter(){
        
        router["foo"] = { UIViewController() }
        
    }
    
    
}
