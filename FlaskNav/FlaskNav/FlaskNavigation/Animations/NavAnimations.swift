//
//  NavAnimationFactory.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavAnimations: NSObject {

    static func animator(from:String?) -> NavAnimatorClass{
        return NavAnimatorZoom(style: .zoomIn)
    }
 
    static func presentation(from:String?,for presented:UIViewController,from presenting:UIViewController) -> NavPresentationController{
        return NavPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
