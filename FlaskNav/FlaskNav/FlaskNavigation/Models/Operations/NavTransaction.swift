//
//  NavTransaction.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavTransaction: NSObject {

    let layer:String
    let _stack:NavStack?
    var results:[Bool] = []
    
    init(with layer:String, stack:NavStack? = nil){
        self.layer = layer 
        self._stack = stack
    }
    
    func addResult(_ value:Bool ){
        results.append(value)
    }
    
    func isCompleted()->Bool{
        for value in results {
            if !value { return false }
        }
        return true 
    }
    
    func stack()->NavStack{
        return _stack!
    }
    
}
