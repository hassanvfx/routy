//
//  AsyncViewController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController, FlaskNavAsyncSetup {
    
    func setupWith(navigationContext: NavigationContext, setupCompleted: @escaping () -> Void) {
       
        self.view.backgroundColor = .red
        
        print("payload = \(String(describing: navigationContext.payload))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             setupCompleted()
        }
       
    }
    
    
   

}
