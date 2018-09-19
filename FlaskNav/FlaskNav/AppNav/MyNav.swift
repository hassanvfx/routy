//
//  MyNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum MainControllers:String {
    case Home, Settings, Feed
}



class AppNav: NavigationInfo<MainControllers> {
    
    
    override func  rootViewController<T:UIViewController>()->T{
        return ViewController() as! T
    }
    
    override func configRouter(){
        
        router[MainControllers.Home.rawValue] = { UIViewController() }
        
    }
    
    
}
