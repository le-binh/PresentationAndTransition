//
//  SwipeTransitionAnimator.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class SwipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        let toFrame = transitionContext.finalFrame(for: toViewController)
        
        let presenting = toViewController.presentingViewController == fromViewController
        
        if presenting {
            containerView.addSubview(toView)
            fromView.frame = fromFrame
            toView.frame = toFrame.offsetBy(dx: toFrame.size.width, dy: 0)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
            fromView.frame = fromFrame
            toView.frame = toFrame
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 
            if presenting {
                toView.frame = toFrame
            } else {
                fromView.frame = fromFrame.offsetBy(dx: fromFrame.size.width, dy: 0)
            }
        }) { (_) in
            let cancelled = transitionContext.transitionWasCancelled
            if cancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancelled)
        }
    }
}
