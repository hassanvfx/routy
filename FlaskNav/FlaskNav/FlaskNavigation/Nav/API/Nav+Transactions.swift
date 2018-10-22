//
//  Nav+Transactions.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav{
    
    func transaction(for layer:String,  completion:NavCompletion? = nil, actions:@escaping (NavTransaction)->Void){
        
        let transaction:NavTransaction
        
        if !NavLayer.IsTabAny(layer){
             let stack = self.stack(forLayer: layer)
             transaction = NavTransaction(with: layer, stack: stack)
        }else{
             transaction = NavTransaction(with: layer)
        }
        
      
        let finalize:NavOperationCompletion = { operation, completed in
            
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                operation.complete()
            }
            
        }
        
        let capture = FlaskOperation() { [weak self] operation in
            transaction._stack?.capture()
            self?.stackActive.capture()
            self?.substance.captureState()
            operation.complete()
        }
        
        let resolve = FlaskOperation() { [weak self] operation in
        
            if transaction.isCompleted() {
                transaction._stack?.commit()
                self?.stackActive.commit()
                self?.substance.commitState(){
                     finalize(operation, true)
                }
            } else{
                transaction._stack?.rollback()
                self?.stackActive.rollback()
                self?.substance.rollbackState {
                    finalize(operation, false)
                }
            }
        }
  
        NavStack.enqueue(operation: capture)
        actions(transaction)
        NavStack.enqueue(operation: resolve)
    }
    
    func comp(transaction:NavTransaction, action:@escaping (NavTransaction)->Void){
        
        let finalize:NavOperationCompletion = { operation, completed in
            
            transaction.addResult(completed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                operation.complete()
            }
            
        }
        
        enqueueNavOperation(nav:false, completion: finalize ) {
            print("-------------")
            print("dispatch COMP layer:\(transaction.layer)")
            action(transaction)
        }
        
    }
    
    func nav(transaction:NavTransaction, action:@escaping (NavTransaction)->Void){
        
        let finalize:NavOperationCompletion = { operation, completed in
            
            transaction.addResult(completed)
            
            DispatchQueue.main.async {
                operation.complete()
            }
        }
        
        enqueueNavOperation(nav:true, completion: finalize ) {
            
            print("-------------")
            print("dispatch NAV start \(transaction.layer)")
            action(transaction)
        }
        
    }
}


