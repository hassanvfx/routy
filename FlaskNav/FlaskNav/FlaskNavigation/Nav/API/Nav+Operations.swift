//
//  Operations.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav{
    
    
    func operationsFor(key:Int)->[FlaskNavOperation]{
        if let references = operations[key] {
            return references
        }
        return []
    }
    

    
    func pointerKey(_ key:Any)->String{
        return "\(Unmanaged.passUnretained(key as AnyObject).toOpaque())"
    }
    
    
    func performOperationFor(navOperation:FlaskNavOperation, _ closure:@escaping (FlaskOperation)->Void) {
       
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing SYNC operation for NAV key \(navOperation.name)")
            closure(navOperation.operation!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                navOperation.releaseFlux()
            })
        }
        
        let operation = FlaskOperation(block: debugClosure)
        navOperation.operation = operation
        
        operationQueue.addOperation(operation)
    
    }
    
 
    func startOperationFor(context:NavContext, navOperation:FlaskNavOperation, _ closure:@escaping (FlaskOperation)->Void) {
        
        let key = context.contextId
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing ASYNC operation for key \(navOperation.name) \(key)")
            closure(navOperation.operation!)
        }
        
        let operation = FlaskOperation(block: debugClosure)
        navOperation.operation = operation
        
        print("[+] setting operation for key \(navOperation.name) \(key)")
        
        var references = operationsFor(key:key)
        references.append( navOperation )
        operations[key] = references
        
        operationQueue.addOperation(operation)
        
    }
    

    func intentToCompleteOperationFor(controller:UIViewController){
       
        let rootContext = NavContext.manager.contextRoot(fromViewController: controller)
        
        if let rootContext = rootContext {
            intentToCompleteOperationFor(rootContext:rootContext)
        }else{
            let context = NavContext.manager.context(fromViewController: controller)
            intentToCompleteOperationFor(context:context)
        } 
        
    }
    
    func intentToCompleteOperationFor(rootContext:NavContext){}
    
    func intentToCompleteOperationFor(context aContext:NavContext?){
        
        if aContext == nil{
            assert(false, "context should always be defined")
            return
        }
        let context = aContext!
        
        NavContext.manager.releaseOnPop(context: context)
        let key = context.contextId
        var references = operationsFor(key:key)
        if(references.isEmpty){ return } // ie tab is presenting a nested nav state
        
        let navOperation = references.removeFirst()
        operations[key] = references
        
        print("pending operations for \(key) =\(references.count)")
        print("[-] removing operation for key \(String(describing: navOperation.name)) \(key)")
        
        DispatchQueue.main.async {
            navOperation.releaseFlux()
            print("pending operations for queue =\(self.operationQueue.operations.count)")
        }
    }
}
