//
//  MyNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum Controllers:String {
    case Home, Settings, Feed
}

enum Accesories:String {
    case Login, Share
}



class AppNav: FlaskNav<Controllers,Accesories> {
    
    override func rootController()->UIViewController{
        return ViewController()
    }
    
    override func defineControllers(){
       
        viewControllers[.Home] = { (payload) in UIViewController() }
        viewControllers[.Settings] = { (payload) in UIViewController() }
        viewControllers[.Feed] = { (payload) in UIViewController() }
        
    }
    
    override func defineAccesories() {
        
        accesoryControllers[.Login] = { (payload) in UIViewController() }
        accesoryControllers[.Share] = { (payload) in UIViewController() }
        
        accesoryParents[.Login] = [ .Home, .Feed]
        accesoryParents[.Share] = [ .Feed]
        
        accesoryLayer[.Login] = .First
        accesoryLayer[.Share] = .Second
    }
    
    
    
}
