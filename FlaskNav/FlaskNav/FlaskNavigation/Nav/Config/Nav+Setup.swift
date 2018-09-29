//
//  Nav+Setup.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    
    //    public func setup(withWindow aWindow:UIWindow){
    //
    //        assert(window == nil, "This instance is already setup")
    //        window = aWindow
    //
    
    //
    //        self.window?.rootViewController = self.navController
    //        self.window?.makeKeyAndVisible()
    //
    //    }
    
    func rootController(forTabIndex index:Int)->UIViewController{
        let controller = UIViewController()
        controller.title = "Tab \(index)"
        return controller
    }
    
    
    func tabNav(for index:Int)->UINavigationController{
        
        if let nav = tabNavControllers[index]{
            return nav
        }
        let rootVc = rootController(forTabIndex: index )
        let aNav = UINavigationController(rootViewController: rootVc)
        tabNavControllers[index] = aNav
        return aNav
    }
    
    
    func initNavController(){
       
        let controller = rootController()
        controller.view.backgroundColor = .green
        
        navController = UINavigationController(rootViewController: controller)
        navController?.setNavigationBarHidden(navBarHidden(), animated: false)
        navController?.delegate = self
        
    }
    
    func initTabController(){
        
        tabController = UITabBarController()
        tabController?.tabBar.tintColor = UIColor.black
        
        let tab1 = tabNav(for: 0)
        let tab2 = tabNav(for: 1)
        
        tabController?.viewControllers = [tab1, tab2]
        
        let testController = UIViewController()
        testController.view.backgroundColor = .red
        tab1.pushViewController( testController, animated: false)
        
        assert(navController != nil, "first intantiate the tab controller!")
//        FlaskNav.add(child: tabController!, to: navController!)
    }
    
    func mainController()->UIViewController{
        return navController!
    }
    
    public func setup(withWindow aWindow:UIWindow){
        
        assert(window == nil, "This instance is already setup")
        window = aWindow
        
        initNavController() // do this optionally
        initTabController() // do this optionally
      
        window?.rootViewController = mainController()
        window?.makeKeyAndVisible()

    }
    
    
}

