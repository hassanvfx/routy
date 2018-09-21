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
    func startOperationFor(controller:UIViewController, navLock:FlaskNavLock, name:String="", _ closure:@escaping (FlaskOperation)->Void) -> FlaskNavOperation{
        
        let operation = FlaskOperation(block: closure)
        let navOperation = FlaskNavOperation(operation: operation, navLock: navLock,name: name)
        
        let key = pointerKey(controller)
        print("setting operation for key \(name) \(key)")
        
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
            print("skiping operation for root key \(key)")
            didShowRootCounter += 1
            return
        }
        
        var references = operationsFor(key:key)
        let navOperation = references.removeFirst()
        
        print("removing operation for key \(String(describing: navOperation.name)) \(key)")
        DispatchQueue.main.async {
            navOperation.complete()
        }
        
    }
}
