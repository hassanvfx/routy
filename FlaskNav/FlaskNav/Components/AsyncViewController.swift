//
//  AsyncViewController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController, FlaskNavViewControllerProtocol {
   
    typealias NavInfoType = NavInfo
    var navContext: NavContext?
    var navInfo: NavInfo?
    
    func setupEmptyState() {
        
        
        let colors:[UIColor] = [.red, .green, . blue, .yellow, .white, .purple, .orange, .cyan, .magenta]
        
        let colorIndex = navContext!.contextId % colors.count
//        print("a frame = \(String(describing: view.frame))")
        let color = colors[colorIndex]
        self.view.backgroundColor = color
        
    }
    
    func setupContent(with completionHandle: @escaping FlaskNavCompletionBlock) {
        
        print("payload = \(String(describing: navInfo))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             completionHandle()
        }
       
        navInfo?.callback("callback from controller")
    }


}
