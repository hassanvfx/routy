//
//  Nav+Setup.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{
    public func setup(withWindow aWindow:UIWindow){
        
        assert(window == nil, "This instance is already setup")
        window = aWindow
        
        initNavController()
        initTabController()
        
        window?.rootViewController = mainController()
        window?.makeKeyAndVisible()
        
    }
}


extension FlaskNav{
    
    func mainController()->UIViewController{
        return navInstance(forLayer: NavLayer.Nav())
    }
    
    func initNavController(){
        navInstance(forLayer: NavLayer.Nav())
    }
    
    func mainNav()->UINavigationController{
        return navInstance(forLayer: NavLayer.Nav())
    }

    func rootController(forTabIndex index:Int)->UIViewController{
        let controller = UIViewController()
        controller.title = "Tab \(index)"
        return controller
    }
    
    
    func tabNav(for index:Int)->UINavigationController{
        return navInstance(forLayer: NavLayer.Tab(index))
    }
    
  
    
    func initTabController(){
        
        tabController = UITabBarController()

        var navs:[UINavigationController] = []
        for (index,_) in tabsNameMap{
            let aNav = navInstance(forLayer: NavLayer.Tab(index))
            navs.append(aNav)
        }
        
        tabController?.viewControllers = navs
     
        
    }
    
    
  
}

extension FlaskNav{
    
    @discardableResult
    func navInstance(forLayer layer:String)->UINavigationController{
        
        if let nav = navControllers[layer] {
            return nav
        }
        
        if(NavLayer.IsNav(layer)){
            let mainNav = newMainNavController()
            navControllers[layer] = mainNav
            return mainNav
        }
        
        let index = NavLayer.TabIndex(layer)
        let tabNav = newTabNavController(forTabIndex: index)
        navControllers[layer] = tabNav
        return tabNav
        
    }
    
    func newMainNavController()->UINavigationController{
       
        let root = navRoot!()
        let config = navRootConfig!
        
        root.view.backgroundColor = .green
        root.title = "Root"
        
        let nav = UINavigationController(rootViewController: root)
        nav.setNavigationBarHidden(!config.navBar, animated: config.navBarAnimated)
        nav.delegate = self
        
        let layer = NavLayer.Nav()
        NavContext.manager.contextRoot(forLayer: layer, viewController: root)
        
        return nav
    }
    
    func newTabNavController(forTabIndex index:Int)->UINavigationController{
        
        let constructor = tabs[index]!
        let config = tabsConfig[index]!
        
        let root = constructor()
        
        root.view.backgroundColor = .purple
        root.title = tabsNameMap[index]
        
        let nav = UINavigationController(rootViewController: root)
        nav.setNavigationBarHidden(!config.navBar, animated: config.navBarAnimated)
        nav.delegate = self
        
        let layer = NavLayer.Tab(index)
        NavContext.manager.contextRoot(forLayer: layer, viewController: root)
        
        return nav
    }
}


