//
//  FlaskMavManifest.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit


let ROOT_CONTROLLER = "root"

public typealias ControllerConstructor = () -> UIViewController
public typealias RoutingMap = [String:ControllerConstructor]


public class NavWeakRef<T> where T: AnyObject {
    
    private(set) weak var value: T?
    
    init(value: T?) {
        self.value = value
    }
}

public enum ModalLayers:Int {
    case First, Second, Third, Fourth, Fifth, Sixth, Seventh, Eighth, Ninth, Tenth
}



public enum NavigationAnimations:String,Codable {
    case None, Default
}




