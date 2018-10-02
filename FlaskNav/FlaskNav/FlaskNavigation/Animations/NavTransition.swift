//
//  NavTransition.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavTransitionAnimation{
    
}

class NavTransition:NSObject {
    
    static let DefaultDuration = 2.0

    var isPresenting = false
    var duration:Double
    var animation:NavTransitionAnimation
    weak var viewController:UIViewController?
    weak var fromViewController:UIViewController?
    
    init(viewController:UIViewController,fromViewController:UIViewController, animation:NavTransitionAnimation? = nil, duration:Double? = nil){
        self.viewController = viewController
        self.fromViewController = fromViewController
        self.animation = animation ?? NavTransitionAnimation()
        self.duration = duration ?? NavTransition.DefaultDuration
    }
    
    func present(){
       
    }
}
extension NavTransition:UIViewControllerTransitioningDelegate{
    
}

extension NavTransition:UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //TODO: magic
    }
    

    
}
