//
//  Nav+ Queue.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask


extension FlaskNav{

    func enqueueNavOperation(nav:Bool, completion:@escaping NavOperationCompletion, action:@escaping ()->Void){

  
        let action:(FlaskOperation)->Void = { [weak self] operation in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            action()
            NavStack.unlock()
            
            self?.dispatchFlux(nav:nav, with: operation){ (completed) in
                completion(operation,completed)
            }
            
        }
        
        let operation = FlaskOperation(block: action)
        NavStack.enqueue(operation: operation)
    }
    


    func isCanceled(operation:FlaskOperation)->Bool{
        if let name = operation.name {
            return name == CANCELED_OPERATION_NAME
        }
        return false
    }
    
    
    
}
