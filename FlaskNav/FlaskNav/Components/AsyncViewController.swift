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
        let info = context.payload
        let color = info!["color"]
        
        switch color {
        case "red":
            self.view.backgroundColor = .red
        case "green":
            self.view.backgroundColor = .green
        case "blue":
            self.view.backgroundColor = .blue
        case "yellow":
            self.view.backgroundColor = .yellow
        default:
            self.view.backgroundColor = .red
        }
        
    }
    
    func asyncSetup(withContext context:NavigationContext, setupFinalizer:@escaping FlaskNavCompletionBlock) {
       
        print("payload = \(String(describing: context.payload))")
        print("message = \(String(describing: context.payload!["message"]))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             setupFinalizer()
        }
       
    }


}
