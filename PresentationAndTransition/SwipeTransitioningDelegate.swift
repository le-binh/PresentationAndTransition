//
//  SwipeTransitioningDelegate.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class SwipeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    var shouldEnableInteractiveTransition = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let edgePanGestureRecognizer = self.edgePanGestureRecognizer, shouldEnableInteractiveTransition else { return nil }
        return SwipeTransitionInteractionController(edgePanGestureRecognizer: edgePanGestureRecognizer)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let edgePanGestureRecognizer = self.edgePanGestureRecognizer, shouldEnableInteractiveTransition else { return nil }
        return SwipeTransitionInteractionController(edgePanGestureRecognizer: edgePanGestureRecognizer)
    }
}
