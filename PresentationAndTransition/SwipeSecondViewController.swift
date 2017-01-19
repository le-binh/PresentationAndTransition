//
//  SwipeSecondViewController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class SwipeSecondViewController: UIViewController {

    fileprivate var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(gestureRecognizerDidUpdate(_:)))
        edgePanGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgePanGestureRecognizer)
    }
    
    func gestureRecognizerDidUpdate(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            dismiss(sender)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        let swipeTransitioningDelegate = transitioningDelegate as? SwipeTransitioningDelegate
        swipeTransitioningDelegate?.shouldEnableInteractiveTransition = sender is UIScreenEdgePanGestureRecognizer
        swipeTransitioningDelegate?.edgePanGestureRecognizer = edgePanGestureRecognizer
        
        dismiss()
    }
    
    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        edgePanGestureRecognizer.removeTarget(self, action: #selector(gestureRecognizerDidUpdate(_:)))
    }
}
