//
//  AsyncViewController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController, FlaskNavAsyncSetup {
    
    func asyncInit(withContext context: NavigationContext) {
        
        self.view.backgroundColor = .red
    }
    
    func asyncSetup(withContext context:NavigationContext, setupFinalizer:@escaping FlaskNavCompletionBlock) {
       
        print("payload = \(String(describing: context.payload))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             setupFinalizer()
        }
       
    }


}
