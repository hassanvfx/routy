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
    
    override func defineRouter(){
        
        defineNavRoot(){ ViewController() }
        
        defineTabRoot(.Main){ AsyncViewController() }
        defineTabRoot(.Friends){ AsyncViewController() }
    
        define(controller: .Home){ AsyncViewController()}
        define(controller: .Settings){ AsyncViewController()}
        define(controller: .Feed){ AsyncViewController()}
        
        define(modal: .Login){ AsyncViewController() }
        define(modal: .Share){ AsyncViewController() }
        
    }
    
    
   
    
    
    
}
