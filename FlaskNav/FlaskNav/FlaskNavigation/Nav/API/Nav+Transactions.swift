//
//  Nav+Transactions.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    func activeLayerTransaction(for layer:String, batched:Bool,  completion:CompletionClosure?, action:@escaping (String)->Void){
        
        var onCompletion:CompletionClosure? = { [weak self] completed in
            if completed {
                self?.stackActiveLayer.commit()
            } else {
                self?.stackActiveLayer.rollback()
            }
            if let userCompletion = completion {
                userCompletion(completed)
            }
        }
        if batched { onCompletion = nil }
        
        stackOperation(batched:batched, completion: onCompletion ) { [weak self] in
            self?.stackActiveLayer.capture()
            action(layer)
        }
        
    }
    
    func stackTransaction(for layer:String, batched:Bool,  completion:CompletionClosure?, action:@escaping (String,NavStack)->Void){
        
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
        
        stackOperation(batched:batched, completion: onCompletion ) {
            let stack = self.stack(forLayer: layer)
            
            if !batched { stack.capture() }
            action(layer,stack)
        }
        
    }
}


