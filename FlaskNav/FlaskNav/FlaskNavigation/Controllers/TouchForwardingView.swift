//
//  TouchForwardingView.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class TouchForwardingView: UIView {

    var touchChilds = true
    var forwardingViews:[UIView] = []
    var didTouchOutside = {}
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if touchChilds {
            if let hitView = super.hitTest(point, with: event){
                if  hitView != self {
                    return hitView
                }
            }
        }
        
        for forwardedView in  forwardingViews {
            if let forwardHit = forwardedView.hitTest(point, with: event){
                didTouchOutside()
                return forwardHit
            }
        }
        
        return self
    }

//    if (hitView != self) return hitView;
//
//    for (UIView *passthroughView in self.passthroughViews) {
//    UIView *passthroughHitView = [passthroughView hitTest:[self convertPoint:point toView:passthroughView] withEvent:event];
//    if (passthroughHitView) return passthroughHitView;
//    }
//
//    return self;
//    }
//
//    @end
}
