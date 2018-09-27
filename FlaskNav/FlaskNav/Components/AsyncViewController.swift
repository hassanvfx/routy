//
//  AsyncViewController.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController, RootsController {
    
    typealias NavInfoType = NavInfo
    var navContext: NavContext?
    var navInfo: NavInfo?
    
    func setupEmptyState() {
        
        let color = navInfo?.params!["color"]
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
    
    func setupContent(with completionHandle: @escaping RootsCompletionBlock) {
        
        print("payload = \(String(describing: navInfo))")
        print("frame = \(String(describing: view.frame))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             completionHandle()
        }
       
    }


}
