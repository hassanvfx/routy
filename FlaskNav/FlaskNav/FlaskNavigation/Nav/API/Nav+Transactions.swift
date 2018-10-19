//
//  Nav+Transactions.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    func activeLayerTransaction(for layer:String, batched:Bool,  completion:CompletionClosure? = nil, action:@escaping (String)->Void){
        
        let finalize:OperationCompletionClosure = { operation, completed in
            
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
            operation.complete()
        }
        
        var resolveState:OperationCompletionClosure? = { [weak self] operation, completed in
            if completed {
                self?.stackActive.commit()
                self?.substance.commitState(){
                    finalize(operation, completed)
                }
            } else {
                self?.stackActive.rollback()
                self?.substance.rollbackState(){
                    finalize(operation, completed)
                }
            }
        }
        if batched { resolveState = nil }
        
        enqueueNavOperation(batched:batched, completion: resolveState ) { [weak self] in
            if !batched {
                self?.stackActive.capture()
                self?.substance.captureState()
            }
            action(layer)
        }
        
    }
    
    func navTransaction(for layer:String, batched:Bool,  completion:CompletionClosure? = nil, action:@escaping (String,NavStack)->Void){
        
        let finalize:OperationCompletionClosure = { operation, completed in
            
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
            operation.complete()
        }
        
        var resolveState:OperationCompletionClosure? = {  [weak self] operation, completed in
            
            guard let this = self else { return }
            
            let stack = this.stack(forLayer: layer)
            if completed {
                stack.commit()
                this.substance.commitState(){
                    finalize(operation, completed)
                }
            } else {
                stack.rollback()
                this.substance.rollbackState(){
                    finalize(operation, completed)
                }
            }
            
        }
        
        if batched { resolveState = nil }
        
        enqueueNavOperation(batched:batched, completion: resolveState ) { [weak self] in
            
            guard let this = self else { return }
            
            let stack = this.stack(forLayer: layer)
            
            if !batched {
                stack.capture()
                this.substance.captureState()
                
            }
            action(layer,stack)
        }
        
    }
}


