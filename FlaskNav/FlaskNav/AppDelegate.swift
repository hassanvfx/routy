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

        testInteractive()
//        testNativeSync()
//        testRoot()
//        testAnimation()
//        testTransaction()
//        testModal()
//        testTransaction()
        return true
    }
    
    func testInteractive(){
        
        let animator = NavAnimators.SlideTop()
        animator.interactionStart()
        
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"red"]),animator:animator)
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            animator.interactionUpdate(percent: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                 animator.interactionCanceled()
            }
            
        }
        
    }
    
    
    func testNativeSync(){
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"red"]))
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"blue"]))
        Services.router.nav.popCurrent()
    }
    
    func testRoot (){

        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"yellow"])){_ in print("line \(#line)")}
        Services.router.modal.popCurrent()
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
        Services.router.tab(.Home).show()
        Services.router.nav.show()
        
        Services.router.tab(.Friends).push(controller: .Feed, info:NavInfo(params:["color":"red"])){_ in print("line \(#line)")}
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"blue"])){_ in print("line \(#line)")}
        
    }
    func testTransaction(){
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("line \(#line)")}

        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"red"])){_ in print("line \(#line)")}
//        Services.router.modal.show()
        Services.router.modal.popCurrent()  //TODO: THIS LINE IS STUCK
        
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("line \(#line)")}
        
        Services.router.modal.push(controller: .Login, info:NavInfo(params:["color":"yellow"])){_ in print("line \(#line)")}
        Services.router.modal.popCurrent()
        
            
        Services.router.transaction { (batch) in
            batch.nav.push( controller: .Feed, info:NavInfo(params:["color":"red"])){_ in print("line \(#line)")}
            batch.nav.push( controller: .Feed, info:NavInfo(params:["color":"blue"])){_ in print("line \(#line)")}
        }


        Services.router.transaction { (batch) in
            batch.nav.push(controller: .Feed, info:NavInfo(params:["color":"white"])){_ in print("line \(#line)")}
        }

        
        Services.router.tab(.Friends).show()
        Services.router.nav.show()
        
        Services.router.transaction { (batch) in
            batch.nav.popCurrent()
            batch.nav.popCurrent()
        }
        
    
        Services.router.nav.push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("line \(#line)")}
       
        
        Services.router.nav.popToRoot()
        
//        Services.router.tab(0).show()
        Services.router.tab(.Home).push(controller: .Feed, info:NavInfo(params:["color":"yellow"])){_ in print("line \(#line)")}
//.
        
        Services.router.nav.popToRoot()
        Services.router.tab(.Friends).show()
        
//        Services.router.tab(.Main).push(controller:.Feed, info:NavInfo(params:["color":"yellow"]))
//        Services.router.modal().push(controller:.Login, info:NavInfo(params:["color":"yellow"]))
        
    }
    
    func testAPI(){
//        let info = Info(title: "test", color: "red")
//
//        Services.router.composition?.nav.push(controller:.Feed, info:info)
//        Services.router.composition?.nav.popToRoot()
//        Services.router.composition?.nav.push(controller:.Feed, info:info)
//        Services.router.composition?.nav.popToRoot()
//        Services.router.composition?.nav.push(controller:.Feed, info:info)
//        Services.router.composition?.nav.push(controller:.Feed, info:info)
//        Services.router.composition?.nav.push(controller:.Feed, info:info)
//        Services.router.composition?.nav.popToRoot()
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

