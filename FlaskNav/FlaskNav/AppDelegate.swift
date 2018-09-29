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
    var substanceController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        
        window = UIWindow(frame: UIScreen.main.bounds)
        Services.router.setup(withWindow: window!)
        
        testTransaction()
//        testAPI()
        return true
    }
    
    func testTransaction(){
    
        Services.router.transaction { (batch) in
            batch.nav.push( controller:.Home, info:NavInfo(params:["color":"red"]))
            batch.nav.push( controller:.Home, info:NavInfo(params:["color":"blue"]))
        }
        
        
        Services.router.transaction { (batch) in
            batch.nav.push(controller:.Home, info:NavInfo(params:["color":"white"]))
        }
        
        Services.router.tab(0).show()
        Services.router.nav.show()
        
        Services.router.transaction { (batch) in
            batch.nav.popCurrentControler()
            batch.nav.popCurrentControler()
        }
        
        
        
        Services.router.nav.push(controller:.Home, info:NavInfo(params:["color":"yellow"]))
        Services.router.nav.popToRootController()
        
        Services.router.tab(0).show()
        
//
//        Services.router.tab(.Main).push(controller:.Home, info:NavInfo(params:["color":"yellow"]))
//        Services.router.accesory().push(controller:.Login, info:NavInfo(params:["color":"yellow"]))
        
    }
    
    func testAPI(){
        let info = Info(title: "test", color: "red")
        
        Services.router.composition?.nav.push(controller:.Home, info:info)
        Services.router.composition?.nav.popToRootController()
        Services.router.composition?.nav.push(controller:.Home, info:info)
        Services.router.composition?.nav.popToRootController()
        Services.router.composition?.nav.push(controller:.Home, info:info)
        Services.router.composition?.nav.push(controller:.Home, info:info)
        Services.router.composition?.nav.push(controller:.Home, info:info)
        Services.router.composition?.nav.popToRootController()
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

