//
//  NavAnimatorPop.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum NavAnimatorZoomStyle:String,RawInitializable {
    case zoomIn, zoomOut
}

class NavAnimatorZoom: NavAnimatorBasic<NavAnimatorZoomStyle>{

    override open func name()->String{
        return "zoom"
    }
 
    override func applyTransformStyle(controller:UIViewController, parent:UIViewController,in containerView:UIView){
        
        switch _style {
        case .zoomIn:
            let val = 1.0 + _intensity
            controller.view.transform = CGAffineTransform(scaleX: CGFloat(val), y: CGFloat(val))
            
        case .zoomOut:
            let val = 1.0 - _intensity
            controller.view.transform = CGAffineTransform(scaleX: CGFloat(val), y: CGFloat(val))
    
        }
    }
}
