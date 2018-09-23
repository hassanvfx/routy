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

protocol FlaskNavSetup:AnyObject {
    var navContext:NavigationContext?{get set}
    func navContextInit(withContext context:NavigationContext)
    func setupEmptyState()
    func setupContent(with completionHandle:@escaping FlaskNavCompletionBlock)
}

protocol FlaskNavController: FlaskNavSetup {
    associatedtype NavInfoType:CodablePayload
    var navInfo:NavInfoType? {get set}
    var navContext:NavigationContext?{get set}
}

extension FlaskNavController{
    func navContextInit(withContext context:NavigationContext){
        self.navContext = context
        self.navInfo = context.payload()
    }
    func setupEmptyState(){}
}


///




