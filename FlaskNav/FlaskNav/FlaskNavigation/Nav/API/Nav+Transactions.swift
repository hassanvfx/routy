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
        
        var onCompletion:CompletionClosure? = { [weak self] completed in
            if completed {
                self?.stackActive.commit()
                self?.substance.commitState()
            } else {
                self?.stackActive.rollback()
                self?.substance.rollbackState()
            }
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
        }
        if batched { onCompletion = nil }
        
        enqueueNavOperation(batched:batched, completion: onCompletion ) { [weak self] in
            if !batched {
                self?.stackActive.capture()
                self?.substance.captureState()
            }
            action(layer)
        }
        
    }
    
    func navTransaction(for layer:String, batched:Bool,  completion:CompletionClosure? = nil, action:@escaping (String,NavStack)->Void){
        
        var onCompletion:CompletionClosure? = {  [weak self] completed in
            
            guard let this = self else { return }
            
            let stack = this.stack(forLayer: layer)
            if completed {
                stack.commit()
                this.substance.commitState()
            } else {
                stack.rollback()
                this.substance.rollbackState()
            }
            if let userCompletion = completion {
                userCompletion(completed)
            }
        }
        
        if batched { onCompletion = nil }
        
        enqueueNavOperation(batched:batched, completion: onCompletion ) { [weak self] in
            
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


