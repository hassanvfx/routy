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
    var navContext:NavContext?{get set}
    func navContextInit(withContext context:NavContext)
    func setupEmptyState()
    func setupContent(with completionHandle:@escaping FlaskNavCompletionBlock)
}

protocol FlaskNavViewControllerProtocol: FlaskNavSetup {
    associatedtype NavInfoType:Any
    var navInfo:NavInfoType? {get set}
    var navContext:NavContext?{get set}
}

extension FlaskNavViewControllerProtocol{
    func navContextInit(withContext context:NavContext){
        navContext = context
        navInfo = context.info as? NavInfoType
    }
    func setupEmptyState(){}
}


///




