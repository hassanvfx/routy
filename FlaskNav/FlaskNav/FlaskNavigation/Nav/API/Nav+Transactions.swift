//
//  Nav+Transactions.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    func compTransaction(for layer:String,  completion:NavCompletion? = nil, action:@escaping (String)->Void){
        
        let finalize:NavOperationCompletion = { operation, completed in
            
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                operation.complete()
            }
            
        }
        
        let resolveState:NavOperationCompletion = { [weak self] operation, completed in
            
            if completed{
                
            }else{
                
            }
            
            if completed {
                print("dispatch COMP completed")
                self?.stackActive.commit()
                self?.substance.commitState(){
                    finalize(operation, completed)
                }
            } else {
                print("dispatch COMP canceled")
                self?.stackActive.rollback()
                self?.substance.rollbackState(){
                    finalize(operation, completed)
                }
            }
        }
        
        enqueueNavOperation(nav:false, completion: resolveState ) { [weak self] in
            print("-------------")
            print("dispatch COMP layer:\(layer)")
            
            self?.stackActive.capture()
            self?.substance.captureState()
            action(layer)
        }
        
    }
    
    func navTransaction(for layer:String,  completion:NavCompletion? = nil, action:@escaping (String,NavStack)->Void){
        
        let finalize:NavOperationCompletion = { operation, completed in
            
            if let userCompletion = completion {
                userCompletion(completed)
            }
            
            DispatchQueue.main.async {
                operation.complete()
            }
        }
        
        let resolveState:NavOperationCompletion = {  [weak self] operation, completed in
            
          
            
            guard let this = self else { return }
            let stack = this.stack(forLayer: layer)
            
            if completed {
                print("dispatch STACK completed")
                stack.commit()
                this.substance.commitState(){
                    finalize(operation, completed)
                }
            } else {
                print("dispatch STACK canceled")
                stack.rollback()
                this.substance.rollbackState(){
                    finalize(operation, completed)
                }
            }
            
        }
        
        enqueueNavOperation(nav:true, completion: resolveState ) { [weak self] in
            
            print("-------------")
            print("dispatch STACK start \(layer)")
            
            guard let this = self else { return }
            
            let stack = this.stack(forLayer: layer)
            stack.capture()
            this.substance.captureState()
            
            action(layer,stack)
        }
        
    }
}


