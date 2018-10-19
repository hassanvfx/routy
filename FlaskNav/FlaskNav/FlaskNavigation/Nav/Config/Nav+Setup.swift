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
        
        initNav()
        initTab()
        initModal()
        
        window?.rootViewController = mainController()
        window?.makeKeyAndVisible()
        
    }
}


extension FlaskNav{

    func hasModal()->Bool{
        return navControllers[NavLayer.Modal()] != nil
    }
    
    func isTabPresented()->Bool{
        return tabPresentator != nil
    }
    
    func _isModalPresented()->Bool{
        return modalPresentator != nil
    }
    
    public func topMostController()->UIViewController{
        if (isTabPresented()) {
            return tabController!
        }
        
        return mainNav()
    }
    
    func mainController()->UIViewController{
        return mainNav()
    }

}
extension FlaskNav{
    
    //////////

    func mainNav()->FlaskNavigationController{
        return navInstance(forLayer: NavLayer.Nav())
    }
    
    func tabNav(for index:Int)->FlaskNavigationController{
        return navInstance(forLayer: NavLayer.Tab(index))
    }
    
    func modalNav()->FlaskNavigationController{
        return navInstance(forLayer: NavLayer.Modal())
    }

    //////////
  
    func initNav(){
        _=mainNav()
    }
    func initModal(){
        _=modalNav()
    }
    func initTab(){
        
        tabController = UITabBarController()

        var navs:[FlaskNavigationController] = []
        
        for index in 0..<tabsNameMap.count{
            let aNav = navInstance(forLayer: NavLayer.Tab(index))
            navs.append(aNav)
        }
        
        tabController?.viewControllers = navs
      
    }
 
}

extension FlaskNav{
    
    @discardableResult
    func navInstance(forLayer layer:String)->FlaskNavigationController{
        
        if let nav = navControllers[layer] {
            return nav
        }
        
        if(NavLayer.IsNav(layer)){
            let mainNav = newMainNavController()
            navControllers[layer] = mainNav
            return mainNav
        }
        
        if(NavLayer.IsModal(layer)){
            let modalNav = newModalController()
            navControllers[layer] = modalNav
            return modalNav
        }
        
        let index = NavLayer.TabIndex(layer)
        let tabNav = newTabNavController(forTabIndex: index)
        navControllers[layer] = tabNav
        return tabNav
        
    }
    
    func layerNameFor(navController: FlaskNavigationController)->String?{
        
        var layerName:String? = nil
        
        for (layer,nav) in navControllers {
            
            if nav == navController {
                layerName = layer
                break
            }
        }
        
        return layerName
        
    }
}
extension FlaskNav{
    
    func newMainNavController()->FlaskNavigationController{
       
        let root = navRoot!()
        let config = navRootConfig!
        
        root.view.backgroundColor = .green
        root.title = "Root"
        
        let nav = FlaskNavigationController(rootViewController: root)
        nav.setNavigationBarHidden(!config.navBar, animated: config.navBarAnimated)
        nav.delegate = self
        nav.flaskDelegate = self
        
        let layer = NavLayer.Nav()
        NavContext.manager.contextRoot(forLayer: layer, viewController: root)
        
        return nav
    }
    
    func newTabNavController(forTabIndex index:Int)->FlaskNavigationController{
        
        let constructor = tabs[index]!
        let config = tabsConfig[index]!
        
        let root = constructor()
        
        root.view.backgroundColor = .purple
        root.title = tabsNameMap[index]
        
        let nav = FlaskNavigationController(rootViewController: root)
        nav.setNavigationBarHidden(!config.navBar, animated: config.navBarAnimated)
        nav.delegate = self
        nav.flaskDelegate = self
        
        let layer = NavLayer.Tab(index)
        NavContext.manager.contextRoot(forLayer: layer, viewController: root)
        
        return nav
    }
    
    
    /// Creates a new modal controller
    ///
    /// - Discussion: When presenting a view controller in a popover, this presentation style is supported only if the transition style is UIModalTransitionStyleCoverVertical. Attempting to use a different transition style triggers an exception. However, you may use other transition styles (except the partial curl transition) if the parent view controller is not in a popover.
    /// - Returns: New modal navigationController
    func newModalController()->FlaskNavigationController{
        
        let root = ModalRootController()
        let config = modalRootConfig
        
        root.title = "Modal"
        root.config = config
        
        let nav = FlaskNavigationController(rootViewController: root)
        nav.setNavigationBarHidden(!config.navBar, animated: config.navBarAnimated)
        nav.delegate = self
        nav.flaskDelegate = self
        nav._isModal = true 
        
        let layer = NavLayer.Modal()
        NavContext.manager.contextRoot(forLayer: layer, viewController: root)
        
        return nav
    }
}

extension FlaskNav:FlaskNavigationControllerDelegate{
    
    
   
    public func navBarAction(inNav nav: FlaskNavigationController, withBar bar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
       
        guard let layerName = layerNameFor(navController: nav) else {
            return true
        }
        
        if nav._isPerformingNavOperation == false {
            //ie initiated by user tap
            popCurrent(layer: layerName)
            return false
        }
        
        return true
    }
    
    
  
}


