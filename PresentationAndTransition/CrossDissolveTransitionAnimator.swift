//
//  CrossDissolveTransitionAnimator.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class CrossDissolveTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        // In iOS 8, the viewForKey: method was introduced to get views that the
        // animator manipulates.  This method should be preferred over accessing
        // the view of the fromViewController/toViewController directly.
        // It may return nil whenever the animator should not touch the view
        // (based on the presentation style of the incoming view controller).
        // It may also return a different view for the animator to animate.
        //
        // Imagine that you are implementing a presentation similar to form sheet.
        // In this case you would want to add some shadow or decoration around the
        // presented view controller's view. The animator will animate the
        // decoration view instead and the presented view controller's view will
        // be a child of the decoration view.
        fromView.frame = transitionContext.initialFrame(for: fromViewController)
        toView.frame = transitionContext.finalFrame(for: toViewController)
        
        containerView.addSubview(toView)
        
        fromView.alpha = 1
        toView.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 
            fromView.alpha = 0
            toView.alpha = 1
        }) { (_) in
            let cancelled = transitionContext.transitionWasCancelled
            if cancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancelled)
        }
    }
}
