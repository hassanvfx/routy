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

var  MainClass:[MainControllers:AnyObject.Type]{
    return [
        .Home: UIViewController.self,
        .Settings: UIViewController.self,
        .Feed: UIViewController.self,
    ]
}


class AppNav: NavigationInfo {

    
    func  rootViewController<T:UIViewController>()->T{
        return ViewController() as! T
    }
    
}
