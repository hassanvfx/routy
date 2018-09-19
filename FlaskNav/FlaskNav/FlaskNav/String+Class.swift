//
//  String+Class.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/15/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

//
//  String+AnyClass.swift
//  Adminer
//
//  Created by Ondrej Rafaj on 14/07/2017.
//  Copyright © 2017 manGoweb UK Ltd. All rights reserved.
//

import Foundation


extension String {
    
    func convertToClass<T>() -> T.Type? {
        return StringClassConverter<T>.convert(string: self)
    }
    
}

class StringClassConverter<T> {
    
    static func convert(string className: String) -> T.Type? {
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        guard let aClass: T.Type = NSClassFromString("\(nameSpace).\(className)") as? T.Type else {
            return nil
        }
        return aClass
        
    }
    
}
