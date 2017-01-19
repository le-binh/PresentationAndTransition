//
//  CrossDissolveFirstViewController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class CrossDissolveFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let presentedViewController = segue.destination
        
        // Setting the modalPresentationStyle to FullScreen enables the
        // <ContextTransitioning> to provide more accurate initial and final frames
        // of the participating view controllers
        presentedViewController.modalPresentationStyle = .fullScreen
        
        presentedViewController.transitioningDelegate = self
    }
}

extension CrossDissolveFirstViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }
}
