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
            } else {
                self?.stackActive.rollback()
            }
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
        }
        if batched { onCompletion = nil }
        
        enqueueNavOperation(type: .Active, batched:batched, completion: onCompletion ) { [weak self] in
            if !batched { self?.stackActive.capture() }
            action(layer)
        }
        
    }
    
    func navTransaction(for layer:String, batched:Bool,  completion:CompletionClosure? = nil, action:@escaping (String,NavStack)->Void){
        
        var onCompletion:CompletionClosure? = { completed in
            let stack = self.stack(forLayer: layer)
            if completed {
                stack.commit()
            } else {
                stack.rollback()
            }
            if let userCompletion = completion {
                userCompletion(completed)
            }
        }
        
        if batched { onCompletion = nil }
        
        enqueueNavOperation(type: .Navigation, batched:batched, completion: onCompletion ) {
            let stack = self.stack(forLayer: layer)
            
            if !batched { stack.capture() }
            action(layer,stack)
        }
        
    }
}


