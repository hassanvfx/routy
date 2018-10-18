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

    func enqueueNavOperation( batched:Bool, completion:CompletionClosure?, action:@escaping ()->Void){

        if batched {
            assert(completion == nil, "Completion is not supported in batch transactions")
            action()
        } else{
            let completionClosure = completion ?? { _ in }
            enqueueNavOperationNow(action: action, completion: completionClosure)
        }
    }
    
    func enqueueNavOperationNow(action closure:@escaping ()->Void, completion:@escaping (Bool)->Void){
        
        
        let action:(FlaskOperation)->Void = { [weak self] operation in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            closure()
            NavStack.unlock()
            self?.dispatchFlux(with: operation){ (completed) in
                
                if completed == false {
                    print("dispatch canceled")
                }
                
                completion(completed)
            }
        }
        
        let operation = FlaskOperation(block: action)
        NavStack.enqueue(operation: operation)
    }
    
    
    func batch(_ closure:@escaping (NavComposition<TABS,CONT,MODS>)->Void){
        
         let action:(FlaskOperation)->Void = { [weak self] operation in
        
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            if let this = self {
                closure(this.compositionBatch!)
            }
            self?.dispatchFlux(with: operation){ (completed) in
                NavStack.unlock()
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
