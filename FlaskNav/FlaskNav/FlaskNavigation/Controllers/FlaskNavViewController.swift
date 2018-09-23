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

protocol FlaskNavInit:AnyObject {
    var navContext:NavigationContext?{get set}
    func navContextInit(withContext context:NavigationContext)
    func setupEmptyState()
}
extension FlaskNavInit{
    func navContextInit(withContext context:NavigationContext){
        self.navContext = context
    }
    func setupEmptyState(){}
}
protocol FlaskNavSetup:FlaskNavInit {
    func setupContent()
}
protocol FlaskNavSetupAsync:FlaskNavInit {
    func setupContent(with asyncCompletion:@escaping FlaskNavCompletionBlock)
}


