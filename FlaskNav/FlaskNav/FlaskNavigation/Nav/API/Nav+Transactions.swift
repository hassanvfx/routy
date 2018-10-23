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
                print("transaction FINISHED layer:\(transaction.layer)")
                print("<<<<<<<<<<<<<<")
            }
            
        }
        
        let capture = FlaskOperation() { [weak self] operation in
           
            print(">>>>>>>>>>>>")
            print("transaction START layer:\(transaction.layer)")
            
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
        
        let sync = FlaskOperation() { [weak self]  operation in
            self?.syncWithDisplay()
            operation.complete()
        }
  
        NavStack.enqueue(operation: capture)
        actions(transaction)
        NavStack.enqueue(operation: resolve)
        NavStack.enqueue(operation: sync)
        
    }
    
    func enqueue(transaction:NavTransaction, type:NavOperationType, action:@escaping (NavTransaction)->Void){
        
        let finalize:NavOperationCompletion = { operation, completed in
            transaction.addResult(completed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                operation.complete()
            }
        }
        
        enqueueNavOperation(type: type, completion: finalize ) {
            print("-------------")
            print("dispatch START type:\(type) layer:\(transaction.layer)")
            action(transaction)
        }
    }
    
   
}


