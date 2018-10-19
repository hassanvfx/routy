//
//  AppDelegate.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

@UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)
        Services.router.setup(withWindow: window!)

//        testInteractivity()
//        nonInteractiveTests()
        testOne()
//        testForever()
//        testBlackRootError()
        return true
    }
    
    func testInteractivityAndContinue(){
        testInteractorTabPushGesture(){
            self.testInteractorModalPushGesture(){
                self.testInteractorPushGesture(){
                    self.nonInteractiveTests()
                }
            }
        }
    }
    
    func testInteractivity(){
        testInteractorTabPushGesture(){
            self.testInteractorModalPushGesture(){
                self.testInteractorPushGesture(){
                    self.testInteractivity()
                }
            }
        }
    }
    
    func testInteractive(){
        testInteractorTabPushGesture()
        testInteractorModalPushGesture()
        testInteractorPushGesture()
    }
    
    func testOne(){
        testInteractive()
        nonInteractiveTests()
    }
    func testForever(){
        testOne()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
            self.testForever()
        }

    }
    
    func nonInteractiveTests(){
        testErrorOct16()
        testInteractorPush()
        testInteractorShowTabs()
        testContextCallbacks()
        testModalDismiss()
        testShowAnimators()
        testMixedAnimators()
        testCompletion()
        testAsyncStack()
        testNativeSync()
        testRoot()
        testAnimation()
        testTransaction()
        testModal()
        testError()
    }
    
    
        
    
    func testErrorOct16(){
        
         let modalIn = NavAnimators.SlideLeft()
        let modalOut = NavAnimators.SlideLeft()
        let modalOut2 = NavAnimators.SlideLeft()
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["color":"yellow"]), animator:modalIn){_ in print("---> line \(#line)")}
        Services.router.nav.show(animator: modalOut){_ in print("---> line \(#line)")}
        Services.router.tab(.Home).show(animator: modalOut2){_ in print("---> line \(#line)")}
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}
        
    }
    
    func testInteractorTabPushGesture(_ completion:@escaping ()->Void = {}) {
        let animator = NavAnimators.SlideLeft()
        let navGesture = NavGesturePan(completesAt:0.5){ gesture in }
        animator.dismissGestures = [navGesture]
        
        animator.onHideCompletion = { completed in
            if completed {
                completion()
            }
        }
        
        Services.router.tab(.Home).show(animator: animator)
    }
    
    func testInteractorModalPushGesture(_ completion:@escaping ()->Void = {}) {
        
        let animator = NavAnimators.SlideLeft()
        let navGesture = NavGesturePan(completesAt:0.5){ gesture in }
        animator.dismissGestures = [navGesture]
        
        animator.onHideCompletion = { completed in
            if completed {
                completion()
            }
        }
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["color":"yellow"]), animator:animator){_ in print("---> line \(#line)")}
        
    }
    
    func testInteractorPushGesture(_ completion:@escaping ()->Void = {}) {
        
        let animator = NavAnimators.SlideLeft()
        let navGesture = NavGesturePan(completesAt:0.5){ gesture in }
        animator.dismissGestures = [navGesture]
        
        animator.onHideCompletion = { completed in
            if completed {
                completion()
            }
        }
        
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"yellow"]), animator:animator){_ in print("---> line \(#line)")}

    }
    
    func testInteractorPush() {
        let animator = NavAnimators.SlideTop()
        animator.onInteractionRequest = { interactor  in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                interactor.interactionUpdate(percent: 0.5)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                interactor.interactionCanceled()
            })
            
        }
        
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"yellow"]), animator:animator){_ in print("---> line \(#line)")}
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"white"])){_ in print("---> line \(#line)")}
    
        Services.router.nav.popCurrent(animator:animator)
    }
    
    func testInteractorShowTabs() {
        
        let animator = NavAnimators.SlideTop()
        animator.onInteractionRequest = { interactor  in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                interactor.interactionUpdate(percent: 0.5)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                interactor.interactionCanceled()
            })
            
        }
        
        Services.router.tab(.Home).show()
//        Services.router.tab(.Home).show() //this causes error
        Services.router.tabAny.hide(animator: animator)
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"white"])){_ in print("---> line \(#line)")}
        
    }
    
    func testContextCallbacks(){
        let info = NavInfo(params:["color":"yellow"])
        info.onWillInit = { nav, con in
            let controller = con as! AsyncViewController
            print("will init \(String(describing: controller.navInfo?.params))");
        }
        info.onDidInit = { nav, con in
            print("did init");
        }
        info.onWillSetupEmptyState = { nav, con in
            print("will setupEmtpy");
        }
        info.onDidSetupEmptyState = { nav, con in
            print("did setupEmtpy");
        }
        info.onWillSetupContent = { nav, con in
            print("will setupContent");
        }
        info.onDidSetupContent = { nav, con in
            print("did setupContent");
        }
        info.onDidSetup = { nav, con in
            print("did Setup");
        }
        info.callback = { _ in
            
        }
        
        
        Services.router.modal.push(controller: .Login, info: info)
       
    }
    
    func testModalDismiss(){
        let slider = NavAnimators.SlideTop()
        let out = NavAnimators.SlideLeft()
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["color":"yellow"]), animator:slider)
        Services.router.modal.dismiss(animator:out)
    }
  
    
    func testShowAnimators(){
         let slider = NavAnimators.SlideTop()
         let out = NavAnimators.SlideLeft()
        
         Services.router.tab(.Friends).show(animator: slider)
         Services.router.tab.hide(animator: out)
        
         Services.router.modal.push(controller: .Login, info: NavInfo(params:["color":"yellow"]), animator:slider)
         Services.router.modal.dismiss(animator:out)
    }
    
    func testMixedAnimators(){
        
        let slider = NavAnimators.SlideTop()
        let zoomer = NavAnimators.ZoomOut()
        
        
        let modalIn = NavAnimators.SlideBottom()
        let modalOut = NavAnimators.SlideLeft()
        
        
        let modalOut2 = NavAnimators.SlideLeft()
        
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"yellow"]), animator:slider){_ in print("---> line \(#line)")}
        Services.router.nav.popCurrent(animator: zoomer){_ in print("---> line \(#line)")}
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["color":"yellow"]), animator:modalIn){_ in print("---> line \(#line)")}
        Services.router.nav.show(animator: modalOut){_ in print("---> line \(#line)")}
        Services.router.tab(.Home).show(animator: modalOut2){_ in print("---> line \(#line)")}
    }
    
    func testCompletion(){
        
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}
        Services.router.tab(.Friends).show(){_ in print("---> line \(#line)")}
      
        Services.router.nav.show(){_ in print("---> line \(#line)")}
    }
    
    func testAsyncStack(){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}

        Services.router.tab(.Friends).show(){_ in print("---> line \(#line)")}
        Services.router.nav.show(){_ in print("---> line \(#line)")}
    }
    
    func testNativeSync(){
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"red"])){_ in print("---> line \(#line)")}
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"blue"])){_ in print("---> line \(#line)")}
        Services.router.nav.popCurrent(){_ in print("---> line \(#line)")}

    }
    
    func testRoot (){


        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}
        Services.router.modal.popCurrent(){_ in print("---> line \(#line)")}

        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"red"]))
        
    }
    
    func testAnimation (){
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"yellow"]))
    }
    
    func testModal(){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"]))
        
        //        Services.router.modal.show()
        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"yellow"]))
        //        Services.router.modal.popCurrent()
        //        Services.router.nav.show()
    }
    func testTabAnimation(){

        Services.router.tab(.Home).show(){_ in print("---> line \(#line)")}
        Services.router.nav.show(){_ in print("---> line \(#line)")}

        
        Services.router.tab(.Friends).push(controller: .Feed, info:NavInfo(params:["color":"red"])){_ in print("---> line \(#line)")}
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"blue"])){_ in print("---> line \(#line)")}
        
    }
    func testTransaction(){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}

        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"red"])){_ in print("---> line \(#line)")}
//        Services.router.modal.show(){_ in print("---> line \(#line)")}
        Services.router.modal.popCurrent(){_ in print("---> line \(#line)")}
        
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}
        

        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}
        Services.router.modal.popCurrent(){_ in print("---> line \(#line)")}
        

        
        Services.router.tab(.Friends).show(){_ in print("---> line \(#line)")}
        Services.router.nav.show(){_ in print("---> line \(#line)")}

    
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in
            print("---> line \(#line)")}
       
        

        Services.router.nav.popToRoot(){_ in print("---> line \(#line)")}

        
//        Services.router.tab(0).show()
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("---> line \(#line)")}
//.
        

        Services.router.nav.popToRoot(){_ in print("---> line \(#line)")}
        Services.router.tab(.Friends).show(){_ in print("---> line \(#line)")}

        
//        Services.router.tab(.Main).push(controller:.Feed, info:NavInfo(params:["color":"yellow"]))
//        Services.router.modal().push(controller:.Login, info:NavInfo(params:["color":"yellow"]))
        
    }
    
    func testError(){
        
//        Services.router.nav.popToRoot(){_ in print("---> line \(#line)")}
//        Services.router.tab(.Friends).show(){_ in print("---> line \(#line)")}
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"purple"])){_ in print("---> line \(#line)")}
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

