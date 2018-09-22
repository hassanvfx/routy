//
//  AsyncViewController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController, FlaskNavSetupAsync {

    var navContext: NavigationContext?
    
    func setupEmptyState() {
        
        let info = navContext?.payload
        let color = info!["color"]
        print("a frame = \(String(describing: view.frame))")
        
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
            self.view.backgroundColor = .white
        }
        
    }
    
    func setupContent(with asyncCompletion: @escaping FlaskNavCompletionBlock) {
        
        print("payload = \(String(describing: navContext?.payload))")
        print("message = \(String(describing: navContext?.payload!["message"]))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             asyncCompletion()
        }
       
    }


}
