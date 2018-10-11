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

    
    public func queueIntent(batched:Bool, completion:CompletionClosure?, action:@escaping ()->Void){

        if batched {
            assert(completion == nil, "Completion is not supported in batch transactions")
            action()
        } else{
            let completionClosure = completion ?? { _ in }
            queueNow(action,completion: completionClosure)
        }
    }
    
    func queueNow(_ closure:@escaping ()->Void, completion:@escaping (Bool)->Void){
        
        
        let action:(FlaskOperation)->Void = { [weak self] operation in
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            //NavStack.capture()
            closure()
            NavStack.unlock()
            self?.dispatchStack(with: operation){ (completed) in
                
                if completed == false {
                    //NavStack.restore()
                    print("dispatch canceled")
                }
                
                completion(completed)
            }
        }
        
        let operation = FlaskOperation(block: action)
        NavStack.enqueue(operation: operation)
    }
    
    
    func transaction(_ closure:@escaping (NavComposition<TABS,CONT,MODS>)->Void){
        
         let action:(FlaskOperation)->Void = { [weak self] operation in
        
            assert(NavStack.locked == false, "error the `stack` is currently locked")
            
            NavStack.lock()
            if let this = self {
                closure(this.compositionBatch!)
            }
            self?.dispatchStack(with: operation){ (completed) in
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
