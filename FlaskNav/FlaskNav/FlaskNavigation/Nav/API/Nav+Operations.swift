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
    
    func performOperationFor(navOperation:FlaskNavOperation, withCompletion closure:@escaping (@escaping (Bool)->Void)->Void) {
       
        let completed = { (completion:Bool) in
            print("[-] removing PRES operation for key \(String(describing: navOperation.name)) ")
            
            navOperation.releaseFlux(completed: completion)
        }
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing PRES operation for key \(navOperation.name)")
            closure(completed)
        }
        
        print("[+] queueing PRES operation for key \(navOperation.name)")
        
        let operation = FlaskOperation(block: debugClosure)
        navOperation.operation = operation
        
        operationQueue.addOperation(operation)
    
    }
    
 
    func startOperationFor(context:NavContext, navOperation:FlaskNavOperation, _ closure:@escaping (FlaskOperation)->Void) {
        
        let key = context.contextId
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing NAV operation for \(context.desc())")
            closure(navOperation.operation!)
        }
        
        let operation = FlaskOperation(block: debugClosure)
        navOperation.operation = operation
        
        print("[+] queueing NAV operation for \(context.desc())")
        
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
    
    func intentToCompleteOperationFor(context aContext:NavContext?,completed:Bool = true, intentRoot:Bool = false){
        
        guard let context = aContext else {
            assert(false, "context should always be defined")
            return
        }
        
        let key = context.contextId
        var references = operationsFor(key:key)
        
        guard let navOperation = references.first else{
            if context.navigator == .Root { return }
            if !intentRoot { return }
            
            let nav = navInstance(forLayer: context.layer)
            let root = nav.rootView()
            let rootContext = NavContext.manager.context(fromViewController: root)
            intentToCompleteOperationFor(context:rootContext, completed: completed)
            return
        }
        
        guard navOperation.operation!.isExecuting else {
            return
        }
        
        _ = references.removeFirst()
        operations[key] = references
           
        print("pending operations for \(key)  =\(references.count)")
        print("[-] removing operation for \(context.desc())")

        if let nav = context.viewController()?.navigationController as? FlaskNavigationController {
            nav._isPerformingNavOperation = false
        }
        if completed {
            NavContext.manager.releaseOnPop(context: context)
        } else{
            NavContext.manager.releaseOnCancel(context: context)
        }
        
        navOperation.releaseFlux(completed: completed)
        print("pending operations for queue =\(self.operationQueue.operations.count)")
        
    }
}
