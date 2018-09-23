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
    var info:Info?
    
    func navContextInit(withContext context: NavigationContext) {
        info = context.payload()
        print("a info = \(String(describing: info))")
    }
    
    func setupEmptyState() {
        
        let color = info?.color
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
        
        print("payload = \(String(describing: info))")
        print("message = \(String(describing: info?.title))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             asyncCompletion()
        }
       
    }


}
