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


class AppNav: FlaskNav<MainControllers> {
    
    override func rootController()->UIViewController{
        return ViewController()
    }
    
    override func defineControllers(){
       
        controllers[.Home] = { (payload) in UIViewController() }
        controllers[.Settings] = { (payload) in UIViewController() }
        controllers[.Feed] = { (payload) in UIViewController() }
        
    }
    
    
}
