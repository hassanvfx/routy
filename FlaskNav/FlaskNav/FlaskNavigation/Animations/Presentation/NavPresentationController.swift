//
//  NavPresentationClass.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public final class NavPresentationClass:  UIPresentationController {
//    var touchForwardingView:TouchForwardingView!
    
    override public var frameOfPresentedViewInContainerView:CGRect {
        return containerView!.bounds
        
//        let height: CGFloat = 200
//        return CGRect(x: 0, y: containerView!.bounds.height - height, width: containerView!.bounds.width, height: height)
    }
    
    override public func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
//        touchForwardingView = TouchForwardingView(frame: containerView!.bounds)
//        touchForwardingView.forwardingViews = [presentingViewController.view];
//        containerView?.insertSubview(touchForwardingView, at: 0)
    }
}
