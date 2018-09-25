//
//  Nav+ Queue.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    public func queueIntent(batched:Bool,action:@escaping ()->Void){
        if batched {
            action()
        } else{
            queueNow(action)
        }
    }
    
    func queueNow(_ closure:@escaping ()->Void){
        
        NavStack.enqueue { [weak self] in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            closure()
            NavStack.unlock()
            self?.applyContext()
        }
    }
    
    
    func transaction(_ closure:@escaping (NavComposition<TABS,CONT,ACCS>)->Void){
        
        NavStack.enqueue { [weak self] in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            if let my = self {
                closure(my.compositionBatch!)
            }
            NavStack.unlock()
            self?.applyContext()
        }
        
    }
    
    
    
}
