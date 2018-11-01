//
//  NavDebug.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavDebug: NSObject {
    
    static let shared = NavDebug()
    
    func active()->Bool{
        return true
    }
    
    func perform(_ closure:()->Void){
        if !active() {return}
        
        closure()
    }
}


