//
//  NavSerializer.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavSerializer {

    static func dictToString(_ params:NSDictionary)->String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            return String(data: jsonData, encoding: .utf8)!
        }catch{
            fatalError("Serialization error")
        }
    }
    static func stringToDict(_ jsonString:String)->NSDictionary{
        
        do{
            let jsonData = jsonString.data(using: .utf8)!
            let info = try JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            return info
        }catch{
            fatalError("serialization error")
        }
    }
}
