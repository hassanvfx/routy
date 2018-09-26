//
//  RootsViewController.swift
//  Roots
//
//  Created by hassan uriostegui on 9/21/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

typealias RootsCompletionBlock = ()->Void

protocol RootsSetup:AnyObject {
    var navContext:NavContext?{get set}
    func navContextInit(withContext context:NavContext)
    func setupEmptyState()
    func setupContent(with completionHandle:@escaping RootsCompletionBlock)
}

protocol RootsController: RootsSetup {
    associatedtype NavInfoType:CodableInfo
    var navInfo:NavInfoType? {get set}
    var navContext:NavContext?{get set}
}

extension RootsController{
    func navContextInit(withContext context:NavContext){
        self.navContext = context
        self.navInfo = context.payload()
    }
    func setupEmptyState(){}
}


///




