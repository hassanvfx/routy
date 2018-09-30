//
//  CodableInfo.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/22/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public protocol CodableInfos:Codable {
    func asJSONString()->String
    static func instance<T>(withJSON string: String) -> T where T : CodableInfos
   
}
extension CodableInfos{
    
    public func asJSONString()->String {
        do{
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8)!
        } catch{
            fatalError("serialization error")
        }
       
    }
    
    public static func instance<T>(withJSON string: String) -> T where T : CodableInfos {
        do{
            let data = string.data(using: .utf8)
            let instance = try JSONDecoder().decode( T.self, from: data! )
            
            return instance
        } catch{
            fatalError("serialization error")
        }
        
    }
    
}


