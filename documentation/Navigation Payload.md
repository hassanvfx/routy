## ✅  Codable Payload

Update: We end up creating the CodablePayload protocol and refactoring the internal property in the NavigationContext to use a string as the raw storage to prevent the need to male it conform to a codable protocol.

#### ✅  Serializable payload

We may use the keyed archiver to turn the structs into data and the data into a json representation.

See here:

https://medium.com/commencis/swift-4s-codable-one-last-battle-for-serialization-30ceb3ccb051

**UPDATE** The above doesn't works unless the struct conforms and implements the NSCoding protocol.

https://craiggrummitt.com/2017/10/04/migrating-to-codable-from-nscoding/

#### ✅ Keep context from protocol in Controller

we should try adding a property to keep the context on the FlaskInit Protocol and automaticallly assign in.

Update:  navContext and navInfo are now resoldved with the FlaskNavController protocol

#### ✅ Payload serialization methods

We may end up creating just 2 methods to easily convert data from structs into payload dictionaries

```swift
Flask.dictionary(from: structInstance)
Flask.instance(from: dictionary, type: Instance.self)
```


## Refactor Flask Storage

Instead of using user defaults we may want to store the data on a separate keyed archiver:

https://medium.com/commencis/swift-4s-codable-one-last-battle-for-serialization-30ceb3ccb051


https://stackoverflow.com/questions/7510123/is-there-any-limit-in-storing-values-in-nsuserdefaults

https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver




## Accesories

Accesories are independent to the current tab and cover the whole application screen. 

Composed over the Root Tab bar controller.

Layers can be composed in layers

Each layer has its own stack.

When displaying the accesories we take the oldest element of each layer

```swift
acessories[Int:  [Context] ]

func stackForLayer(_ layer:Int){
   if let stack = acessories[layer]{
       return stack
   }
   return []
}

func push( stack, context){
    //refactored push method to use a variable stack
}
```

We may consider turning the stack into a class so we can easily mutate its inner dictionary.

We can reuse the existing stack manipulation methods that are common to the navigationController context.

then in the state we can define a dictionary to represent the layers most current state

```swift

struct NavState: State{
    var accesories:[Int:String] = [:]
}
///

func mix(){}
    substance.prop.accesories = [:]

    for index, stack in acessories{
        substance.prop.accesories[0] = stack.current().toString()
    }
}

```

We may encapsulate the stack operations as follows

```swift

class NavStack {
    var stack:[Context] = []
    func pop(..)
    func push(..)
    func current()
}
```



## TabBar Core

We may consider using the tabbarcontroller as the root controller and then attach individual navigation controllers to each tab.



Reference:
https://medium.com/@ITZDERR/uinavigationcontroller-and-uitabbarcontroller-programmatically-swift-3-d85a885a5fd0

```swift

enum Tabs: String{
    case Home, Friends
}

eum Controllers: String{
    case Settings, PhotoDetail
}

class MyNav : FlaskNavM<Tabs, Controllers, Accesories>{

    func defineNavigation(){

        define(tab: .Home){  HomeViewController() }
        define(tab: .Friends){  FriendsViewController() }

        define(controller: .Settings){  HomeViewController() }
        define(controller: .PhotoDetail){  FriendsViewController() }

        define(controller: .Settings){  HomeViewController() }
        define(controller: .PhotoDetail){  FriendsViewController() }

        define(accesory: .Login){ FriendsViewController () }
        define(accesory: .Login, parents:[.Home, .Settings]){                    
            FriendsViewController ()
        }
    }
}

Services.nav.tab(.Home).push(controller: .Settings)
Services.nav.tab(.Home).overlay(accesory: .Login)
Services.nav.tab(.Home).overlay(accesory: .Login, atLayer: .First)
Services.nav.tab(.Home).popCurrentController()

Services.nav.tab(.Home).show()
Services.nav.tab(.Friends).show()

```

We should also offer two methods for push,pop,etc such that the user an pass also constructors from the tabs.

## ✅ Navigation transactions

Navigation transactions: This will be useful to setup the navigation stack to a particular state before resolving the current state (ie. showing multiple accesory controller0 for onboard, permissions, etc.).

```swift

Services.nav.transaction{ (nav) in

   nav.push(controller...)
   nav.overlay(accesory:...)
   nav.overlay(accesory:...)

}

```
ApplyContext will be ignored while a transaction is being defined. 

We should also add the transaction operations inside a queue to ensure atomicity


## Navigation actions

There is an advantage on internally managing the controllers stack as a string based array. We can easily pop the current controller or alter this array and then set the current controller from the last element

* push
    * clear accesories  
    * set new controller
* popCurrent
    * clear accesories  
    * pops the current controller
    * set previous controller
* popTo
    * clear accesories  
    * pops until finds the controller
    * if not set controller
* goTo
    * clear accesories
    * clear navigation stack
    * set controller

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