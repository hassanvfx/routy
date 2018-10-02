//
//  Composer.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/26/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav {
    
    
    static func add(child:UIViewController,to parent:UIViewController,forwardAppearance:Bool = false){
        
        parent.addChildViewController(child)
        child.view.frame = parent.view.bounds
        
        if(forwardAppearance){
            child.beginAppearanceTransition(true, animated: false)
        }
        
        parent.view.addSubview(child.view)
        
        if(forwardAppearance){
            child.endAppearanceTransition()
        }
        
        child.didMove(toParentViewController: parent)
    }
    
    static func remove(child:UIViewController,forwardAppearance:Bool=false){
        if(forwardAppearance){
            child.beginAppearanceTransition(false, animated: false)
        }
        
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        
        if(forwardAppearance){
            child.endAppearanceTransition()
        }
        
        child.removeFromParentViewController()
    }
    
    func presentTop(_ controller:UIViewController, animated:Bool, completion:@escaping ()->Void){
        present(controller,from: topMostController(),animated: animated,completion: completion)
    }
    
    func dismissTop(animated:Bool, completion:@escaping ()->Void){
        dismiss(fromController: topMostController(), animated: animated, completion: completion)
    }
    
    func present(_ controller:UIViewController, from fromController:UIViewController? = nil, animated:Bool, completion:@escaping ()->Void){
        
        if(
            (
                controller.isKind(of: UIAlertController.self) ||
                    controller.isKind(of: UIActivityViewController.self)
                )
                &&
                controller.popoverPresentationController?.sourceView == nil
            ){
            
            controller.popoverPresentationController?.sourceView = mainController().view
            controller.popoverPresentationController?.sourceRect = CGRect(x: mainController().view.bounds.midX, y: mainController().view.bounds.midY, width: 0, height: 0) //CGRectMake(CGRectGetMidX(self.navController.view.bounds), CGRectGetMidY(self.navController.view.bounds),0,0);
            controller.popoverPresentationController?.permittedArrowDirections = .any
        }
        
        let main = fromController ?? mainController()
        main.present(controller, animated: animated, completion: completion)
       
    }
    
    func dismiss(fromController:UIViewController? = nil, animated:Bool, completion:@escaping ()->Void){
        let main = fromController ?? mainController()
        main.dismiss(animated: animated, completion: completion)
    }
        
}



