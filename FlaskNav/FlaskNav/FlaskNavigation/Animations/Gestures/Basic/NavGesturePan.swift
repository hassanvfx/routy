//
//  NavGesturePan.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/14/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavGesturePan: NavGesture<UIPanGestureRecognizer> {
    
    
    override func newGesture(with selector:Selector)->UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer.init(target: self, action: selector)
        return gesture
    }
    
    
    override func progress()->Double {
        guard let gesture = gesture else { return 0}
        guard let view = gesture.view else { return 0}
        
        let translation = gesture.translation(in: gesture.view)
        let translationX = translation.x / view.bounds.size.width
        var percent = min(translationX, 1.0)
        percent = max(percent, 0.0)
        return Double(percent)
    }
    
    
}

