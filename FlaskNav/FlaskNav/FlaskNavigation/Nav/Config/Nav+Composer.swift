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
    
}
extension FlaskNav{
    
    func tabAnimatorParameter()->String{
        let animator = NavAnimatorZoom(style: .zoomIn, intensity: 0.2)
        return animator.asParameter()
    }
    
    func presentTab(animator jsonAnimator:String? = nil, presentator jsonPresentator:String?=nil, completion:@escaping ()->Void){
        if isTabPresented() {return}
        
        let tab = tabController!
        let top = mainController()
        let modalJsonAnimator = jsonAnimator ?? tabAnimatorParameter()
        let animator = NavAnimators.shared.animator(from: modalJsonAnimator)
        let presentation =  NavAnimators.shared.presentation(from: jsonPresentator, for: tab, from:top)
        
        tabPresentator = NavPresentator(presentViewController: tab, from: top, animator: animator, presentation: presentation)
        tabPresentator?.present(completion)
        
    }
    
    func dismissTab(completion:@escaping ()->Void = {}){
         if !isTabPresented() {return}
        
        let onDismiss = { [weak self] in
            self?.tabPresentator = nil
            completion()
        }
        tabPresentator?.dismiss(onDismiss)
    }
}


extension FlaskNav{
    
    func modalAnimatorParameter()->String{
        let animator = NavAnimatorSlide(style: .slideBottom, intensity: 0.5)
        return animator.asParameter()
    }
    
    func presentModal(animator jsonAnimator:String? = nil, presentator jsonPresentator:String?=nil, completion:@escaping ()->Void){
        
        if isModalPresented() {return}
        
        let modal = modalNav()
        let top = topMostController()
        let modalJsonAnimator = jsonAnimator ?? modalAnimatorParameter()
        let animator = NavAnimators.shared.animator(from: modalJsonAnimator)
        let presentation =  NavAnimators.shared.presentation(from: jsonPresentator, for: modal, from:top)
        
        modal.modalRootView().viewForwarder().forwardingViews = [top.view]
        modal.modalRootView().viewForwarder().didTouchOutside = { [weak self] in
            if (self?.isModalPresented())! {
                self?.modal.dismiss()
            }
        }
        
        modalPresentator = NavPresentator(presentViewController: modal, from: top, animator: animator, presentation: presentation)
        modalPresentator?.present(completion)
        
    }
    
    func dismissModal(completion:@escaping ()->Void = {}){
        assert(modalPresentator != nil, "call `presentModal` first")
        let onDismiss = { [weak self] in
            self?.modalPresentator = nil
            completion()
        }
        modalPresentator?.animator._duration = 0
        modalPresentator?.dismiss(onDismiss)
    }
    
}

extension FlaskNav{
    
    func _present(_ controller:UIViewController, from fromController:UIViewController? = nil, animated:Bool, completion:@escaping ()->Void){
        
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
    
    func _dismiss(fromController:UIViewController? = nil, animated:Bool, completion:@escaping ()->Void){
        let main = fromController ?? mainController()
        main.dismiss(animated: animated, completion: completion)
    }
        
}






