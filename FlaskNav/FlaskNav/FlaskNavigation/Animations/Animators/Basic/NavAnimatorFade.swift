//
//  NavAnimatorFade.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/12/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

enum NavAnimatorFadeStyle:String,RawInitializable {
    case FadeOut
}

class NavAnimatorFade: NavAnimatorBasic<NavAnimatorFadeStyle>{
    
  
    override open func preferredIntensity() -> Double {
        return 0.2
    }
    
    override func applyTransformStyle(controller:UIViewController, parent:UIViewController,in containerView:UIView){
        
        controller.view.alpha = CGFloat(1 - _intensity)
        
    }
}
