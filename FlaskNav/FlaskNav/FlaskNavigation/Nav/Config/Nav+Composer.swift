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
    
 
    func presentTab(index:Int, presentation:NavPresentationClass?=nil, completion:@escaping (Bool)->Void){

        if isTabPresented() {
            completion(true)
            return
        }
        
        let tab = tabController!
        let top = mainController()
        let transitionAnimator = takeActiveLayerAnimator(for: NavLayer.TabAny(), withType: .Show)
        let defaultAnimator = NavAnimators.ZoomIn() //TODO: move this to config
        let animator = transitionAnimator ?? defaultAnimator
        
        let myCompletion = {
            completion(!animator.wasCanceled)
        }
        
        tabPresentator = NavPresentator(presentViewController: tab, from: top, animator: animator, presentation: presentation)
        tabPresentator?.present(myCompletion)
        
    }
    
    func dismissTab(completion:@escaping (Bool)->Void = {_ in}){
        if !isTabPresented() {
            completion(true)
            return
        }
        
        let transitionAnimator = takeActiveLayerAnimator(for: NavLayer.TabAny(), withType: .Hide)
        let defaultAnimator = NavAnimators.ZoomIn() //TODO: move this to config
        let animator = transitionAnimator ?? defaultAnimator

        
        let onDismiss = { [weak self] in
            self?.tabPresentator = nil
            completion(!animator.wasCanceled)
        }
        
       
        tabPresentator?.animator = animator
        tabPresentator?.dismiss(onDismiss)
    }
}


extension FlaskNav{
    
    func modalAnimatorParameter()->String{
        let animator = NavAnimatorSlide(style: .slideBottom, intensity: 0.5)
        return animator.asParameter()
    }
    
    func presentModal( presentation:NavPresentationClass?=nil, completion:@escaping ()->Void){
        
        if _isModalPresented() {
            completion()
            return
        }
        
        let modal = modalNav()
        let top = topMostController()
        let animator = NavAnimators.Fade()
        
        modal.modalRootView().viewForwarder().forwardingViews = [top.view]
        modal.modalRootView().viewForwarder().didTouchOutside = { [weak self] in
            if (self?._isModalPresented())! {
                self?.modal.dismiss()
            }
        }
        
        modalPresentator?.animator._duration = 0.1
        modalPresentator = NavPresentator(presentViewController: modal, from: top, animator: animator, presentation: presentation)
        modalPresentator?.present(completion)
        
    }
    
    func dismissModal(completion:@escaping ()->Void = {}){
        
        if !_isModalPresented() {
            completion()
            return
        }
        
        let onDismiss = { [weak self] in
            self?.modalPresentator = nil
            completion()
        }

        //TODO: issue here with unbalanced calls
        modalPresentator?.animator._duration = 0.1
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






