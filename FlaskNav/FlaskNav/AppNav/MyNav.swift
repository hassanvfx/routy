//
//  MyNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum Tabs:String {
    case Main, Friends
}

enum Controllers:String {
    case Home, Settings, Feed
}

enum Accesories:String {
    case Login, Share
}



class MyFlaskNav: FlaskNav<Tabs, Controllers,Accesories> {
    
    override func rootController()->UIViewController{
        return ViewController()
    }
    
    override func defineControllers(){
       
        viewControllers[.Home] = { AsyncViewController() }
        viewControllers[.Settings] = { UIViewController() }
        viewControllers[.Feed] = { UIViewController() }
        
    }
    
    override func defineAccesories() {
        
        accesoryControllers[.Login] = { UIViewController() }
        accesoryControllers[.Share] = {  UIViewController() }
        
        accesoryParents[.Login] = [ .Home, .Feed]
        accesoryParents[.Share] = [ .Feed]
        
        accesoryLayer[.Login] = .First
        accesoryLayer[.Share] = .Second
    }
    
    
    
}
