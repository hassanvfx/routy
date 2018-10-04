//
//  NavAnimationFactory.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


public class NavAnimators: NSObject {
    
    static let ZoomIn = { NavAnimatorZoom(style: .zoomIn,intensity:0.2)}
    static let ZoomOut = { NavAnimatorZoom(style: .zoomOut,intensity:0.2)}
    static let SlideLeft = { NavAnimatorSlide(style: .slideLeft, intensity:1.0)}
    static let SlideRight = { NavAnimatorSlide(style: .slideRight, intensity:1.0)}
    static let SlideTop = { NavAnimatorSlide(style: .slideTop, intensity:1.0)}
    static let SlideBottom = { NavAnimatorSlide(style: .slideBottom, intensity:1.0)}
    
    
}
