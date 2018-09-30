## Managed NavContext

We may consider turning the NavContext into a managed class object. The manager will create and manage the instances, then a serialized version would be rendered with a command like context.toString(). We won't need to actually code/decode but instead we can pull from the factory/manager using the context ID.  This will be useful as now the context is also storing a weak pointer to the controller holding it. We can then have a routine to dispose context where the viewcontroller has turned nil.

## implementation of pop logic

```
  }else{
                self?.popToController(controller, context: context)
            }

```

we started the implementation however the existing navigator method wont work as currently we are always creating a new instance of the controller instead of reusing. W emay need to look into the method used previously using cached controllers from the navController.

The issue remains in that we need to determine the controller as a pointer and not as a type of controller... theoretically we should be able to read the reference from the context but this needs to be stores as the navClosure, then during the pop operation we strack the weakViewcontrolelr pointer from the context!

## navContext disposal

we need to add a handler on the navContext dealloc to remove then the instances in the context manager

## pop navigation
we should include in the navigationContext a prop indicating if the operation is `push` or `pop` . From there when the Navigator is resolving the action, we call push or pop accordingly.

as we do this we should also include the method `popToController(toController)`as part of the nav iterface and then euqally implement it in the logic above

ideally we could use  popToController always instead of just calling pop.  The behavior of popToController will be to push a new instance of the controller if this is nor present.

still in theory the satck and the nav hiearchy should be always in sync

## pop callback resolution

the popCallback will be assigned similar on the `navInfo` is assigned when conformance to the protocol. This method will be the a `navCallback` and could be called multiple times by the controlller.

## pop callback

we have partially integrated the pop callback but we need to find a way to call this when the navigation is poping that given controller

also an extra issue arised, as when we pop a controller, in reality we always push the previous controller. while common sense would expect the navController to call pop instead o pushing the previous controller again


## non codable payload

We replaced the codable by a non codable Any? type for the payload.

The next step is to add the completion closure.

## State Restoration

We should bail in the effort of restoring the whole navigation state. The reason is that this would mix the nav logic with the biz logic beyond a reasonable concern.

For example a user might loggeed out after the app has been closed. Then restoring the previous state would be based in void presumptions.

this means we should consider relaxing the requirements to pass payloads during the nav operations and allow the use of non encodable types. we may also consider including a dismiss block to allow chaining navigation operations once they are resolved.

## Next Steps

We refctored the pipes to assume a normalized structure where all different nav components are StackLayers.

This means that 

* main nav
* tabs
* accessories

all fo them will have a navigation controller implementation.

The above simplifies the manipulation of the nav stack throught the fluxor pipelines.

To determine the active nav style we are now using `LayerActive` . this property indicated both, the type of navigation (tab, nav, accesory) and also the index. 

> Accesories consideration: We may want to consider to separate `AccesoryActive` so this will better represent the fact that we can have both a `layer` and an `accesory layer` active simultaneously.

The next step is to refactor de navigation definition as stated below in this document so it can be the foundation for the multi-layer nav.

Once the definitions are made (specially the tab definitions) we can work in the encapsulation of the navigation-reactions stack so instead of only responding to the main nav, it pulls the navController for that given corresponding layer.

From there the next step will be to define the accesory controllers composition/clear out system.

```swift
Services.router.accesory(0).push(.Login)
```
Accesory controllers might have a completion block that can be invoked from the inside of the controller. this makes sense as usually accesory controller are meant to pull information from the user.

```swift
Services.router.accesory(0).push(.Login){ payload in 
    Services.router.nav.show()
}
```

```swift
class MyAccesoryLogin : NavAccessoryController {

    func foo(){
        dismissAccesory(with: payload)
    }
}
```


## Presenting the TabController

We can use the navController as the main controller and then present the TabBarController using the `presentViewController` method.

During the transition we can revert the composition order to make it seem like the tabBarcontroller is the parent.

This article describes how to implement a custom transitions for this case:

https://medium.com/lifesum-healthy-living-simplified/presenting-a-uiviewcontroller-modally-with-a-transparent-background-the-cool-way-b79eb0abd423


## Challenge with changing root controller

If the nav controller is not present, we won't receive the callabcks from its delegate indicating when the presentations are performed.

That's why we need to enforce the nav type whenever that specific nav operations are requested


## Changing window rootViewcontroller

It is possible to change the window root view controller, this tutorial shows how to perform this with animations:

https://medium.com/@danielemargutti/animate-uiwindows-rootviewcontroller-transitions-2887ccf3fecc

## FRAMEWORK NAME

ROOTS
RUTY



## Using modal presentation for RootController

We may not inlcude the tabController inside the navController but instead  present the tabBarController as a modal controller.

http://www.alexmedearis.com/uitabbarcontroller-inside-a-uinavigationcontroller/

https://developer.apple.com/documentation/uikit/uimodalpresentationstyle?language=objc

## RootController

We may create a root controller that will define the complete empty state of the application.

Then immediately attach a tabController as the only child whenever tabs are enabled.

The above would allow to make a distinction between 

```swift
nav.main.popToRootController()
```

> and

```swift
nav.tab(.Home).popToRootController()
```

The above would require that whener we call to present a tab, the main navigation will need to pop until find the tanController.

```
main.tab(0).show()
```

```
main.pop(toController:MAIN_TAB_CONTROLLER)
tab.show()
```

It should always be the first element in the stack

```
[TabController]
```

## Tab accessor with index

We should allow to also access the tabs by index like:

```swift
nav.tab(0).popToRootController()
nav.tab().popToRootController()
```

## Passing Composition state to flux

We need to define how to store the composition state such that the keys can be easily observed.

For example for accesories we can obserbe keys like

```swift
reaction.on("accesories.layer0"){ change in }
reaction.on("accesories.layer1"){ change in }
reaction.on("accesories.layer2"){ change in }
reaction.on("accesories.layer2"){ change in }
```

like wise we can apply the same logic for the tabs 

```swift
reaction.on("tabs.layer0"){ change in }
reaction.on("tabs.layer1"){ change in }
reaction.on("tabs.layer2"){ change in }
reaction.on("tabs.layer2"){ change in }
```

for the sake of simiplication, we could define a hardcoded limit on the number of components, for example 10 layers and 10 tabs. This would allow us to define this as specific state vars like

```swift
reaction.on(.Tab0){ change in }
reaction.on(.Tab1){ change in }
reaction.on(.Tab2){ change in }
reaction.on(.Tab3){ change in }


reaction.on(.AccesoryLayer0){ change in }
reaction.on(.AccesoryLayer1){ change in }
reaction.on(.AccesoryLayer2){ change in }
reaction.on(.AccesoryLayer3){ change in }

```

The tricky part is that we would need to map the tabs into a position to match the numeric index. This could be resolved during the tab definition:

```swift
define(tab: .Home, index:0){  HomeViewController() }
define(tab: .Friends, index:1){  HomeViewController() }
```


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