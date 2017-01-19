//
//  AdaptivePresentationSecondViewController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/19/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class AdaptivePresentationSecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In the regular environment, AAPLAdaptivePresentationController displays
        // a close button for the presented view controller.  For the compact
        // environment, a 'dismiss' button is added to this view controller's
        // navigationItem.  This button will be picked up and displayed in the
        // navigation bar of the navigation controller returned by
        // -presentationController:viewControllerForAdaptivePresentationStyle:
        addDismissBarButton()
    }
    
    // For an adaptive presentation, the presentation controller's delegate
    // must be configured prior to invoking
    // -presentViewController:animated:completion:.  This ensures the
    // presentation is able to properly adapt if the initial presentation
    // environment is compact.
    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            presentationController?.delegate = self
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func addDismissBarButton() {
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissButtonTapped(_ :)))
        navigationItem.leftBarButtonItem = dismissButton
    }
}


extension AdaptivePresentationSecondViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // An adaptive presentation may only fallback to
        // UIModalPresentationFullScreen or UIModalPresentationOverFullScreen
        // in the horizontally compact environment.  Other presentation styles
        // are interpreted as UIModalPresentationNone - no adaptation occurs.
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}
