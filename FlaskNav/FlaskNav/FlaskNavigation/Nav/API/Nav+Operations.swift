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
    
    
    func performOperationFor(navOperation:FlaskNavOperation, withCompletion closure:@escaping (@escaping ()->Void)->Void) {
       
        let completed = {
            print("[-] removing SYNC operation for key \(String(describing: navOperation.name)) ")
            
            navOperation.releaseFlux()
        }
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing SYNC operation for key \(navOperation.name)")
            closure(completed)
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
    
    func intentToCompleteOperationFor(rootContext:NavContext){
        print("Should complete Root Context: \(rootContext.layer)")
        intentToCompleteOperationFor(context:rootContext)
    }
    
    func intentToCompleteOperationFor(context aContext:NavContext?){
        
        guard let context = aContext else {
            assert(false, "context should always be defined")
            return
        }
        
        
        
        
        let key = context.contextId
        var references = operationsFor(key:key)
        
        guard let navOperation = references.first else{
            return
        }
        
        guard navOperation.operation!.isExecuting else {
            return
        }
        
        
        _ = references.removeFirst()
        operations[key] = references
           
        print("pending operations for \(key)  =\(references.count)")
        print("[-] removing operation for key \(String(describing: navOperation.name)) \(key) \(String(describing: context.navigator?.rawValue))")
        

        navOperation.releaseFlux()
        print("pending operations for queue =\(self.operationQueue.operations.count)")
        
        if let nav = context.viewController()?.navigationController as? FlaskNavigationController {
            nav._isPerformingNavOperation = false
        }
        
        NavContext.manager.releaseOnPop(context: context)
        
    }
}
