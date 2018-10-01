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

enum Modals:String {
    case Login, Share
}



class MyFlaskNav: FlaskNav<Tabs, Controllers,Modals> {
    
    override func rootController()->UIViewController{
        return ViewController()
    }
    
    override func defineControllers(){
       
        viewControllers[.Home] = { AsyncViewController() }
        viewControllers[.Settings] = { UIViewController() }
        viewControllers[.Feed] = { UIViewController() }
        
    }
    
    override func defineModals() {
        
        modalControllers[.Login] = { UIViewController() }
        modalControllers[.Share] = {  UIViewController() }
        
        modalParents[.Login] = [ .Home, .Feed]
        modalParents[.Share] = [ .Feed]
        
        modalLayer[.Login] = .First
        modalLayer[.Share] = .Second
    }
    
    
    
}
