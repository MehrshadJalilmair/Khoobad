//
//  TransitionPresentationAnimator.swift
//  PresentationTutorial
//
//  Created by Sztanyi Szabolcs on 17/11/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = self .transitionDuration(transitionContext)
        
        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        toViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
        toViewController.view.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        toViewController.view.layer.shadowOpacity = 0.3
        toViewController.view.layer.cornerRadius = 4.0
        toViewController.view.clipsToBounds = true
        
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            toViewController.view.transform = CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(finished)
        })
    }
}