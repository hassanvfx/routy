//
//  FlaskNavigationController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class FlaskNavigationController: UINavigationController {

    func rootView()->UIViewController{
        return viewControllers.first!
    }
    
    func modalRootView()->ModalRootController{
        return viewControllers.first! as! ModalRootController
    }
}


