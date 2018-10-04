//
//  NavPresentationClass.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

final class NavPresentationClass:  UIPresentationController {
//    var touchForwardingView:TouchForwardingView!
    
    override var frameOfPresentedViewInContainerView:CGRect {
        return containerView!.bounds
        
//        let height: CGFloat = 200
//        return CGRect(x: 0, y: containerView!.bounds.height - height, width: containerView!.bounds.width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
//        touchForwardingView = TouchForwardingView(frame: containerView!.bounds)
//        touchForwardingView.forwardingViews = [presentingViewController.view];
//        containerView?.insertSubview(touchForwardingView, at: 0)
    }
}
