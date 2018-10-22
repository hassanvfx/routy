//
//  Nav+Config.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


extension FlaskNav{
    
    
    public func defineNavRoot(config:NavConfig = NavConfig(navBar: true), _ constructor:@escaping NavConstructor){
        navRoot = constructor
        navRootConfig = config
    }
    public func defineTabRoot(_ tab:TABS, config:NavConfig? = NavConfig(navBar: true, tabBar:true), _ constructor:@escaping NavConstructor){
        let stringKey = tab.rawValue as! String
        let index = tabs.count
        tabs[index] = constructor
        tabsConfig[index] = config
        
        tabsNameMap[index] = stringKey
        tabsIndexMap[stringKey] = index
    }
    
    public func defineModal( config:NavConfig){
        modalRootConfig = config
    }
    
    public func define(controller:CONT,_ constructor:@escaping NavConstructor){
        let stringKey = controller.rawValue as! String
        controllers[stringKey] = constructor
    }
    
    public func define(modal:MODS,_ constructor:@escaping NavConstructor){
        let stringKey = modal.rawValue as! String
        modals[stringKey] = constructor
    }
}

extension FlaskNav{
    
    func configRouter(){
        defineRouting()
        assertRouting()
    }
    
    func assertRouting(){
        
        assert(navRoot != nil,"`defineNavRoot` must be called in `defineRouting`")
       
        assert(tabs.count == tabsNameMap.count,"must match")
        assert(tabs.count == tabsIndexMap.count,"must match")
        
        //TODO: assert all enums are implemented
    }
}

