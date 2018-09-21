//
//  FlaskNavViewController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

typealias FlaskNavCompletionBlock = ()->Void

class FlaskNavOperation {

    weak var operation:FlaskOperation?
    let navLock:FlaskNavLock
    let name:String
    
    init(operation:FlaskOperation,navLock:FlaskNavLock,name:String){
        self.operation = operation
        self.navLock = navLock
        self.name = name
    }
    
    func complete(){
        self.operation?.complete()
        self.navLock.releaseFluxIntent()
    }
}


class FlaskNavLock {
    
    public let fluxLock : FluxLock
    public private(set)  var navLocked = false
    
    init(fluxLock:FluxLock) {
        self.fluxLock = fluxLock
    }
    
    func lockNavigation(){
        navLocked = true
    }
    
    func releaseNavigation(){
        navLocked = false
        releaseFluxIntent()
    }

    
    func releaseFluxIntent(){
        if navLocked {
            return
        }
        fluxLock.release()
    }
}

protocol FlaskNavAsyncSetup {
    
    func setupWith(navigationContext:NavigationContext, setupCompleted:@escaping FlaskNavCompletionBlock)
  
}


