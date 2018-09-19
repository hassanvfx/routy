//
//  FlaskNav.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class FlaskNav {

    var window: UIWindow?
    var navController: UINavigationController?
    var stack:[String] = []
    let info:NavigationInfoConcrete
    
    init(info:NavigationInfoConcrete) {
        self.info = info
    }
    
    public func setup(withWindow aWindow:UIWindow){
        
        assert(window == nil, "This instance is already setup")
        window = aWindow
   
        let rootController = self.info.rootViewController()
        navController = UINavigationController(rootViewController: rootController)
        navController?.setNavigationBarHidden(self.info.navBarHidden(), animated: false)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    
    func presentController(path:String){
        
        let constructor = self.info.constructorFor(path)
        let controller = constructor()
      
    }
    
}
