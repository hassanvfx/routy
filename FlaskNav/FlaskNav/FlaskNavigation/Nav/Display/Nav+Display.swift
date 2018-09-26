//
//  Nav+Display.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension Roots{
    
    func pushController(_ controller:UIViewController, context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let animated = context.animation != .None
            self?.navController?.pushViewController(controller, animated: animated)
            
        }
    }
    
    func popToController(_ controller:UIViewController,  context:NavContext){
        DispatchQueue.main.async { [weak self] in
            let animated = context.animation != .None
            self?.navController?.popToViewController(controller, animated: animated)
        }
    }
    
}

extension Roots {
    
    
    func presentAccessory(_ controller:UIViewController,  context:NavContext){
        
    }
    
    
}

