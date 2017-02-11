//
//  DetailPresentationController.swift
//  PresentationTutorial
//
//  Created by Sztanyi Szabolcs on 17/11/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class DetailPresentationController: UIPresentationController {
    
    var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        setupDimmingView()
    }
    
    func setupDimmingView() {
        dimmingView = UIView(frame: presentingViewController.view.bounds)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = dimmingView.bounds
        visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        dimmingView.addSubview(visualEffectView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailPresentationController.dimmingViewTapped(_:)))
        dimmingView.addGestureRecognizer(tapRecognizer)
    }
    
    func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView
        let presentedViewController = self.presentedViewController
        
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        
        containerView!.insertSubview(dimmingView, atIndex: 0)
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (coordinatorContext) -> Void in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (coordinatorContext) -> Void in
            self.dimmingView.alpha = 0.0
            }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView()!.frame = frameOfPresentedViewInContainerView()
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        //let currentDevice = UIDevice.currentDevice().userInterfaceIdiom
        
        return CGSizeMake(parentSize.width - 40.0, parentSize.height - 80.0)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        var presentedViewFrame = CGRectZero
        let containerBounds = containerView!.bounds
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        
        presentedViewFrame.origin.x = 20.0
        presentedViewFrame.origin.y = 40.0
        
        return presentedViewFrame
        
        /*var presentedViewFrame = CGRectZero
        let containerBounds = containerView!.bounds
        
        let contentContainer = presentedViewController
        presentedViewFrame.size = sizeForChildContentContainer(contentContainer, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = 20.0
        presentedViewFrame.origin.y = 40.0
        
        return presentedViewFrame*/
    }
}