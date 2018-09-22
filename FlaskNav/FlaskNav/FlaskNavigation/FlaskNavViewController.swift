//
//  FlaskNavViewController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

typealias FlaskNavCompletionBlock = ()->Void

protocol FlaskNavInit {
    func asyncInit(withContext context:NavigationContext)
}
extension FlaskNavInit{
    func asyncInit(withContext context:NavigationContext){}
}
protocol FlaskNavSetup:FlaskNavInit {
    func setup(withContext context:NavigationContext)
}
protocol FlaskNavAsyncSetup:FlaskNavInit {
    func asyncSetup(withContext context:NavigationContext, setupFinalizer:@escaping FlaskNavCompletionBlock)
}


