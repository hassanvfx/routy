//
//  FlaskNavigationController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class FlaskNavigationController: UINavigationController, UINavigationBarDelegate {

    var isModal = false
    
    func rootView()->UIViewController{
        return viewControllers.first!
    }
    
    func modalRootView()->ModalRootController{
        assert(isModal,"this controller is not modal")
        return viewControllers.first! as! ModalRootController
    }
    
    override func loadView() {
        super.loadView()
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
//    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool{
//
//        return true
//    } // called to push. return NO not to.
//
//    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem){
//
//    } // called at end of animation of push or immediately if not animated
    
   
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool{
         return false
    }
    
   
//    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem){
//
//    }

}


