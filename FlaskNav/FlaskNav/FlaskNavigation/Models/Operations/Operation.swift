//
//  Operation.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

class FlaskNavOperation : NSObject {
    
    weak var operation:FlaskOperation?
    public let fluxLock : FluxLock
    let name:String
    public private(set) var navLocked = false
    public private(set) var pendingRelease = false
    
    init(fluxLock:FluxLock,name:String){
        self.operation = nil
        self.fluxLock = fluxLock
        self.name = name
    }
    
    
    func lockNavigation(){
        navLocked = true
    }
    
    func releaseNavigation(){
        navLocked = false
        if pendingRelease == true{
            releaseFlux()
        }
    }
    
    func releaseFlux(completed:Bool = true){
//        DispatchQueue.main.async {
            if self.navLocked {
                self.pendingRelease = true
                return
            }
            self.operation!.complete()
            self.fluxLock.release(context: completed)
//        }
    }
    
    
}

