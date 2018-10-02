//
//  InactiveBackView.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class InactiveBackView: UIView {

    public var allowTouches = false
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        for view in self.subviews {
            if view.isUserInteractionEnabled
                && view.isHidden == false {
                return view.point(inside: point, with: event)
            }
        }
        return false || allowTouches
    }
}
