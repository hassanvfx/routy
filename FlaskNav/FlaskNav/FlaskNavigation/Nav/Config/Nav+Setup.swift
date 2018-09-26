//
//  Nav+Setup.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension Roots{
    
    public func setup(withWindow aWindow:UIWindow){
        
        assert(window == nil, "This instance is already setup")
        window = aWindow
        
        let rootController = self.rootController()
        rootController.view.backgroundColor = .green
        
        self.navController = UINavigationController(rootViewController: rootController)
        self.navController?.setNavigationBarHidden(self.navBarHidden(), animated: false)
        self.navController?.delegate = self
        
        self.window?.rootViewController = self.navController
        self.window?.makeKeyAndVisible()
        
    }
    
}

