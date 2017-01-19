//
//  SwipeFirstViewController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class SwipeFirstViewController: UIViewController {
    fileprivate var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private lazy var swipeTransitioningDelegate: SwipeTransitioningDelegate = {
       return SwipeTransitioningDelegate()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(gestureRecognizerDidUpdate(_:)))
        edgePanGestureRecognizer.edges = .right
        view.addGestureRecognizer(edgePanGestureRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let presentedViewController = segue.destination
        
        swipeTransitioningDelegate.shouldEnableInteractiveTransition = sender is UIScreenEdgePanGestureRecognizer
        swipeTransitioningDelegate.edgePanGestureRecognizer = edgePanGestureRecognizer
        
        // Setting the modalPresentationStyle to FullScreen enables the
        // <ContextTransitioning> to provide more accurate initial and final frames
        // of the participating view controllers
        presentedViewController.modalPresentationStyle = .fullScreen
        
        presentedViewController.transitioningDelegate = swipeTransitioningDelegate
    }
    
    func gestureRecognizerDidUpdate(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            performSegue(withIdentifier: "SwipeCustomTransition", sender: sender)
        }
    }
    
    deinit {
        edgePanGestureRecognizer.removeTarget(self, action: #selector(gestureRecognizerDidUpdate(_:)))
    }
}
