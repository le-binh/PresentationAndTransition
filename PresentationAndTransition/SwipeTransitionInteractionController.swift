//
//  SwipeTransitionInteractionController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    private var transitionContext: UIViewControllerContextTransitioning!
    private let edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer
    
    init(edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        self.edgePanGestureRecognizer = edgePanGestureRecognizer
        super.init()
        self.edgePanGestureRecognizer.addTarget(self, action: #selector(gestureRecognizerDidUpdate(_:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        self.transitionContext = transitionContext
    }
    
    func gestureRecognizerDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            update(percentComplete(for: gestureRecognizer))
        case .ended:
            if shouldCompleteTransition(for: gestureRecognizer) {
                finish()
            } else {
                cancel()
            }
        default:
            cancel()
            break
        }
    }
    
    private func percentComplete(for gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        let containerView = transitionContext.containerView
        let location = gestureRecognizer.location(in: containerView)
        let containerViewWidth = containerView.frame.size.width
        if edgePanGestureRecognizer.edges == .right {
            return (containerViewWidth - location.x) / containerViewWidth
        } else if edgePanGestureRecognizer.edges == .left {
            return location.x / containerViewWidth
        } else {
            return 0
        }
        
    }
    
    private func shouldCompleteTransition(for gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return percentComplete(for: gestureRecognizer) >= 0.5
    }
    
    deinit {
        edgePanGestureRecognizer.removeTarget(self, action: #selector(gestureRecognizerDidUpdate(_:)))
    }
}
