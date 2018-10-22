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

//        testInteractorPush()
//        testOnboard()
//        testInteractivity()
//        nonInteractiveTests()
//        testOne()
        testForever()
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
        testInteractorPush()
        testInteractorShowTabs()
    }
    
    func testOne(){
        testInteractive()
        nonInteractiveTests()
    }
    func testForever(){
//        testInteractive()
        nonInteractiveTests(){
            self.testForever()
        }

    }
    
    func nonInteractiveTests(_ completion:@escaping ()->Void = {}){
        testErrorOct16()
        testContextCallbacks()
        testModalDismiss()
        testShowAnimators()
        testMixedAnimators()
        testCompletion()
        testAsyncStack()
        testNativeSync()
        testRoot()
        testAnimation()
        testModal()
        testError()
        testLast(completion)
    }
    
    
    func testOnboard(){
        
        let sharedInfo = NavInfo()
        sharedInfo.setCallback(){ context, payload in
 
            
            switch context.controller {
            case Modals.Login.rawValue:
                Services.router.modal.push(controller: .Login, info: NavInfo(callback: sharedInfo.getCallback())){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
                break;
            default:
                break;
            }
        }
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["name":"anyName"], callback: sharedInfo.getCallback())){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
    }
        
    
    func testErrorOct16(){
        
         let modalIn = NavAnimators.SlideLeft()
        let modalOut = NavAnimators.SlideLeft()
        let modalOut2 = NavAnimators.SlideLeft()
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["name":"anyName"]), animator:modalIn){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.show(animator: modalOut){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Home).show(animator: modalOut2){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
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
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["name":"anyName"]), animator:animator){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
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
        
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["name":"anyName"]), animator:animator){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

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
        
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["name":"anyName"]), animator:animator){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"white"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
    
        Services.router.nav.popCurrent(animator:animator){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
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
        
        Services.router.tab(.Home).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
//        Services.router.tab(.Home).show() //this causes error
        Services.router.tabs.hide(animator: animator){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["color":"white"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
    }
    
    func testContextCallbacks(){
        let info = NavInfo(params:["name":"anyName"])
        info.onWillInit = { nav, con in
            let controller = con.viewController() as! AsyncViewController
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
        info.setCallback(){ context, _ in
            print("callback from \(context.desc())");
        }
        
        
        Services.router.modal.push(controller: .Login, info: info)
       
    }
    
    func testModalDismiss(){
        let slider = NavAnimators.SlideTop()
        let out = NavAnimators.SlideLeft()
        
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["name":"anyName"]), animator:slider)
        Services.router.modal.dismiss(animator:out)
    }
  
    
    func testShowAnimators(){
         let slider = NavAnimators.SlideTop()
         let out = NavAnimators.SlideLeft()
        
         Services.router.tab(.Friends).show(animator: slider)
         Services.router.tab.hide(animator: out)
        
         Services.router.modal.push(controller: .Login, info: NavInfo(params:["name":"anyName"]), animator:slider)
         Services.router.modal.dismiss(animator:out)
    }
    
    func testMixedAnimators(){
        
        let slider = NavAnimators.SlideTop()
        let zoomer = NavAnimators.ZoomOut()
        
        
        let modalIn = NavAnimators.SlideBottom()
        let modalOut = NavAnimators.SlideLeft()
        
        
        let modalOut2 = NavAnimators.SlideLeft()
        
        Services.router.nav.push(controller: .Feed, info: NavInfo(params:["name":"anyName"]), animator:slider){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.popCurrent(animator: zoomer){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.modal.push(controller: .Login, info: NavInfo(params:["name":"anyName"]), animator:modalIn){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.show(animator: modalOut){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Home).show(animator: modalOut2){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
    }
    
    func testCompletion(){
        
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Friends).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
      
        Services.router.nav.show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
    }
    
    func testAsyncStack(){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

        Services.router.tab(.Friends).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
    }
    
    func testNativeSync(){
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"red"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"blue"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.popCurrent(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

    }
    
    func testRoot (){


        Services.router.modal.push(controller: .Login, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.modal.popCurrent(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"red"]))
        
    }
    
    func testAnimation (){
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["name":"anyName"]))
    }
    
    func testModal(){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"]))
        
        //        Services.router.modal.show()
        Services.router.modal.push(controller: .Login, info:NavInfo(params:["name":"anyName"]))
        //        Services.router.modal.popCurrent()
        //        Services.router.nav.show()
    }
    func testTabAnimation(){

        Services.router.tab(.Home).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

        
        Services.router.tab(.Friends).push(controller: .Feed, info:NavInfo(params:["color":"red"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"blue"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
    }
    func testLast(_ completion:@escaping ()->Void){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"red"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
//        Services.router.modal.show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.modal.popCurrent(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        

        Services.router.modal.push(controller: .Login, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.modal.popCurrent(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        

        
        Services.router.tab(.Friends).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.nav.show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

    
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
       
        

        Services.router.nav.popToRoot(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }

        
//        Services.router.tab(0).show()
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["name":"anyName"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
//.
        

        Services.router.nav.popToRoot(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Friends).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)"); completion() }

        
//        Services.router.tab(.Main).push(controller:.Feed, info:NavInfo(params:["name":"anyName"]))
//        Services.router.modal().push(controller:.Login, info:NavInfo(params:["name":"anyName"]))
        
    }
    
    func testError(){
        
//        Services.router.nav.popToRoot(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
//        Services.router.tab(.Friends).show(){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"purple"])){ context, completed in print("---> line \(#line) \(context.desc()) \(completed)") }
        
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

