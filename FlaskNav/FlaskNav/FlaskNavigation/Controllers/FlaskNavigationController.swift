//
//  FlaskNavigationController.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/2/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

public protocol FlaskNavigationControllerDelegate:AnyObject{
    func navBarAction(inNav nab:FlaskNavigationController, withBar bar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool

}
public class FlaskNavigationController: UINavigationController, UINavigationBarDelegate {

    public weak var flaskDelegate:FlaskNavigationControllerDelegate?
    public var _isModal = false
    public var _isPerformingNavOperation = false
    
    func rootView()->UIViewController{
        return viewControllers.first!
    }
    
    func modalRootView()->ModalRootController{
        assert(_isModal,"this controller is not modal")
        return viewControllers.first! as! ModalRootController
    }
    
    override public func loadView() {
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
        guard let delegate = self.flaskDelegate else{
            return true
        }
        return delegate.navBarAction(inNav: self,withBar: navigationBar,shouldPop:item)
    }
    
   
//    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem){
//
//    }

}


