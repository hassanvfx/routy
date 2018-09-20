## Operation Queue

We need to refactor the Flask operation queue to use an Async operation instead of pausing/ releasing the queue

## Concerns

When initializing a substance wiuth the `NewSubstance(definedBy:)` we may need to consider how to handle naming.

## Nesting 

We may want to apply nesting on the nav hierarchy such that we can append another FlaskNavController as a child. 

If we do this we need to require passing the name

## Navigation Payload

By forcing the payload to be Codable, we can completely dehidrate and recreate the state of any view controller.


# Navigation lock

we need to pass the reaction lock all the way down to the transition lock resolver

```  
            reaction.onLock?.release()
            self?.navigateToCurrentController()
```

Needs to ve resolved in

```
public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        let rootController = activeRootController()
        let key = pointerKey(viewController)
        
        if viewController == rootController &&
            didShowRootCounter < FIRST_NAVIGATION_ROOT_COUNT {
            print("skiping operation for root key \(key)")
            didShowRootCounter += 1
            return
        }
        
        var references = operationsFor(key:key)
        let ref = references.removeFirst()
        
        if let operation = ref.value {
            operations[key] = references
            
            print("removing operation for key \(String(describing: operation.name)) \(key)")
            DispatchQueue.main.async {
                operation.complete()
            }
            
            
        }else{
            
            print("ignoring operation for key \(key)")
        }
        
    }
```