
//
//  Nav+Dispatcher.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/24/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
import Flask

extension FlaskNav{
    func applyContext(){
        let context = self.stack(forLayer: StackLayer.Main()).current()
        Flask.lock(withMixer: NavMixers.Controller, payload: ["context":context.toString()])
    }
}
