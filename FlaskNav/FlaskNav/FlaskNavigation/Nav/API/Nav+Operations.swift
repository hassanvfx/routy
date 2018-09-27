//
//  Operations.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension Roots{
    
    
    func operationsFor(key:String)->[RootsOperation]{
        if let references = operations[key] {
            return references
        }
        return []
    }
    

    
    func pointerKey(_ key:Any)->String{
        return "\(Unmanaged.passUnretained(key as AnyObject).toOpaque())"
    }
    
    
    func startOperationFor(navOperation:RootsOperation, _ closure:@escaping (FlaskOperation)->Void) {
       
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing operation for key \(navOperation.name)")
            closure(navOperation.operation!)
        }
        
        let operation = FlaskOperation(block: debugClosure)
        navOperation.operation = operation
        
        operationQueue.addOperation(operation)
    
    }
    
 
    func startOperationFor(controller:UIViewController, navOperation:RootsOperation, _ closure:@escaping (FlaskOperation)->Void) {
        
        let key = pointerKey(controller)
        
        let debugClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing operation for key \(navOperation.name) \(key)")
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
    
    func completeOperationFor(controller:UIViewController){
        
        let rootController = activeRootController()
        let key = pointerKey(controller)
        
        if controller == rootController &&
            didShowRootCounter < FIRST_NAVIGATION_ROOT_COUNT {
            print("[ ] skiping operation for root key \(key)")
            didShowRootCounter += 1
            return
        }
        
        var references = operationsFor(key:key)
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
