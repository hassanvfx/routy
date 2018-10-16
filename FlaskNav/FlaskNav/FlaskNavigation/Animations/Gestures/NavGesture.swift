//
//  NavGesture.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/14/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit
public enum NavGestureType : String {
    case ZoomIn, ZoomOut, PanLeft, PanRight, PanTop, panB
}
public class NavGestureAbstract : NSObject {
    open func addTo(view aView:UIView, animator:NavAnimatorClass){}
    public func removeFromView(){}
}

public typealias NavGestureCallback = (NavGestureAbstract)->Void

public class NavGesture<T:UIGestureRecognizer>: NavGestureAbstract {

    public private(set) weak var view:UIView?
    public private(set) var gesture:T?
    public private(set) var animator:NavAnimatorClass?
    public private(set) var callback:NavGestureCallback?
    public private(set) var completesAt:Double 
    
    public init(completesAt:Double = 0.5, _ callback:NavGestureCallback? = nil){
        self.callback = callback
        self.completesAt = completesAt
    }
    
    override public func addTo(view aView:UIView, animator:NavAnimatorClass){
        
        if self.view == aView { return }
        
        removeFromView()
        
        let aGesture:T = newGesture(with: #selector(onGestureSelector(_:)))
        aView.addGestureRecognizer(aGesture)
        
        self.view = aView
        self.gesture = aGesture
        self.animator = animator
    }
    
    override public func removeFromView(){
        
        guard let view = view else { return }
        guard let gesture = gesture else { return }

        view.removeGestureRecognizer(gesture)
    }
    
    open func newGesture(with selector:Selector)->T {
        return T.init()
    }
    
    @objc
    open func onGestureSelector(_ gesture:UIGestureRecognizer){
        
        callback?(self)
        
        print("gesture state:\(gesture.state.rawValue)")
            
        switch gesture.state {
        case .possible:
            onGesturePossible()
            break
        case .began:
            onGestureBegan()
            break
        case .changed:
            onGestureChange()
            break
        case .ended:
            onGestureEnded()
            break
        case .cancelled:
            onGestureCanceled()
            break
        case .failed:
            onGestureFailed()
            break
        }
    }
    
    open func onGesturePossible() {}
    
    open func onGestureBegan() {
        self.animator?.dissmisGestureStarted(self,gesture: gesture!)
    }
    
    open func onGestureChange() {
        self.animator?.interactionUpdate(percent: progress())
    }
    
    open func onGestureEnded() {
        if progress() >= completesAt {
            animator?.interactionFinished()
        } else{
            animator?.interactionCanceled()
        }
    }
    open func onGestureCanceled() {
        animator?.interactionCanceled()
    }
    
    open func onGestureFailed() {
        animator?.interactionCanceled()
    }
    
    
    open func progress()->Double {
        assert(false,"must be overriden by subclass")
        return 0
    }
}
