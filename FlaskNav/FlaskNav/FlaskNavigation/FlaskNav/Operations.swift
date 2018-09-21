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
    
    @discardableResult
    func startOperationFor(controller:UIViewController, navOperation:FlaskNavOperation, _ closure:@escaping (FlaskOperation)->Void) -> FlaskNavOperation{
        
        let key = pointerKey(controller)
        
        let newClosure:(FlaskOperation)->Void = { (op) in
            print("[$] performing operation for key \(navOperation.name) \(key)")
            closure(navOperation.operation!)
        }
        
        let operation = FlaskOperation(block: newClosure)
        navOperation.operation = operation
        
        
        print("[+] setting operation for key \(navOperation.name) \(key)")
        
        var references = operationsFor(key:key)
        references.append( navOperation )
        operations[key] = references
        
        operationQueue.addOperation(operation)
        return navOperation
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
        
        print("[-] removing operation for key \(String(describing: navOperation.name)) \(key)")
        DispatchQueue.main.async {
            navOperation.releaseFlux()
        }
        
    }
}
