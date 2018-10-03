//
//  NavAnimationFactory.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public class NavAnimators: NSObject {
    
    static public let POPUP = {NavAnimatorZoom(style:.zoomIn,intensity:0.2,duration:0.5)}()
    
    static public let SLIDE_LEFT = {NavAnimatorSlide(style:.slideLeft,intensity:1.0)}()
    static public let SLIDE_RIGHT = {NavAnimatorSlide(style:.slideRight,intensity:1.0)}()
    static public let SLIDE_TOP = {NavAnimatorSlide(style:.slideTop,intensity:1.0)}()
    static public let SLIDE_BOTTOM = {NavAnimatorSlide(style:.slideBottom,intensity:1.0)}()
    
    static public let ZOOM_IN = {NavAnimatorZoom(style:.zoomIn,intensity:0.2)}()
    static public let ZOOM_OUT = {NavAnimatorZoom(style:.zoomOut,intensity:0.2)}()
}
