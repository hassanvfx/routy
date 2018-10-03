//
//  NavAnimatorSlide.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public enum NavAnimatorSlideStyle:String,RawInitializable {
    case slideLeft, slideRight, slideTop, slideBottom
}

public class NavAnimatorSlide: NavAnimatorBasic<NavAnimatorSlideStyle>{
    
    override open func name()->String{
        return "slide"
    }
    
    override open func preferredIntensity() -> Double {
        return 1.0
    }
    
    override open func applyTransformStyle(controller:UIViewController, parent:UIViewController,in containerView:UIView){
        
        if _intensity < 0.9 {
            controller.view.alpha = 0
        }
        
        let xDisp = Double(containerView.bounds.width) * _intensity
        let yDisp = Double(containerView.bounds.height) * _intensity
        
        switch _style {
        case .slideLeft:
            controller.view.transform = CGAffineTransform(translationX: CGFloat(xDisp), y: 0)
        case .slideRight:
            controller.view.transform = CGAffineTransform(translationX: CGFloat(-xDisp), y: 0)
        case .slideBottom:
            controller.view.transform = CGAffineTransform(translationX : 0, y: CGFloat(yDisp))
        case .slideTop:
            controller.view.transform = CGAffineTransform(translationX : 0, y: CGFloat(-yDisp))
  
        }
    }
}

