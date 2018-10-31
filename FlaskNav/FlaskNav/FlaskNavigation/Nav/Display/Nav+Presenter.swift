//
//  Composer.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 9/26/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

extension FlaskNav{

    func presentTab(index:Int, presentation:NavPresentationClass?=nil, completion:@escaping (Bool)->Void){

        if isTabPresented() {
            print("skiped SHOW tab")
            completion(true)
            return
        }
        
        let tab = tabController!
        let top = mainController()
        let transitionAnimator = getActiveLayerAnimator(for: NavLayer.TabAny(), withType: .Show)
        let defaultAnimator = NavAnimators.ZoomIn() //TODO: move this to config
        let animator = transitionAnimator ?? defaultAnimator
        
        let myCompletion = { [weak self] in
            print("did SHOW tab")
            
            if(!animator.canceledInteraction){
                self?.removeActiveLayerAnimator(for: NavLayer.TabAny(), withType: .Show)
            }
            completion(!animator.canceledInteraction)
        }
        
        animator.onRequestDismiss = { [weak self]  (navGesture, gesture) in
            
            animator.enableInteraction()
            
            if gesture.state == .began {
                self?.tabs.hide()
            }
        }
        
        
        print("will SHOW tab")
        
        tabPresentator = NavPresentator(presentViewController: tab, from: top, animator: animator, presentation: presentation)
        
        dismissModal(){ [weak self] in
            self?.tabPresentator?.present(myCompletion)
        }
       
        
    }
    
    func dismissTab(completion:@escaping (Bool)->Void = {_ in}){
        if !isTabPresented() {
            print("skiped HIDE tab")
            completion(true)
            return
        }
        
        let transitionAnimator = getActiveLayerAnimator(for: NavLayer.TabAny(), withType: .Hide)
        let defaultAnimator = NavAnimators.ZoomIn() //TODO: move this to config
        let animator = transitionAnimator ?? defaultAnimator

        
        let onDismiss = { [weak self] in
              print("did HIDE tab")
            if !animator.canceledInteraction {
                self?.removeActiveLayerAnimator(for: NavLayer.TabAny(), withType: .Hide)
                self?.tabPresentator = nil
            }
            completion(!animator.canceledInteraction)
        }
        
        animator.onRequestDismiss = { [weak self]  (navGesture, gesture) in
            
            if gesture.state == .began {
                self?.tabs.hide()
            }
        }
        
        print("will HIDE tab")
        tabPresentator?.animator = animator
        dismissModal() { [weak self] in
            self?.tabPresentator?.dismiss(onDismiss)
        }
        
    }
}


extension FlaskNav{
    
    func modalAnimatorParameter()->String{
        let animator = NavAnimatorSlide(style: .slideBottom, intensity: 0.5)
        return animator.asParameter()
    }
    
    func presentModal( presentation:NavPresentationClass?=nil, completion:@escaping ()->Void){
        
        if isModalPresented() {
            print("skiped SHOW modal")
            completion()
            return
        }
        
        let modal = modalNav()
        let top = topMostController()
        let animator = NavAnimators.Fade()
        
        modal.modalRootView().viewForwarder().forwardingViews = [top.view]
        modal.modalRootView().viewForwarder().didTouchOutside = { [weak self] in
            if (self?.isModalPresented())! {
                self?.modal.dismiss()
            }
        }
        
        let onFinish = { 
            print("did SHOW modal")
            completion()
            
        }
        
        print("will SHOW modal")
        modalPresentator?.animator._duration = 0.1
        modalPresentator = NavPresentator(presentViewController: modal, from: top, animator: animator, presentation: presentation)
        modalPresentator?.present(onFinish)
        
    }
    
    func dismissModal(completion:@escaping ()->Void = {}){
        
        if !isModalPresented() {
            print("skip HIDE modal")
            completion()
            return
        }
        
        let onDismiss = { [weak self] in
            print("did HIDE modal")
            self?.modalPresentator = nil
            completion()
            
        }

        print("will HIDE modal")
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




