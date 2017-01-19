//
//  AdaptivePresentationController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/19/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class AdaptivePresentationController: UIPresentationController {
    private var dismissButton: UIButton?
    private var presentationWrappingView: UIView?
    
    //MARK:- LifeCycle
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var presentedView: UIView? {
        return presentationWrappingView
    }
    
    override func presentationTransitionWillBegin() {
        configureCustomViews()
    }
    
    //MARK:- Layout
    
    //| ----------------------------------------------------------------------------
    //  This method is invoked when the interface rotates.  For performance,
    //  the shadow on presentationWrapperView is disabled for the duration
    //  of the rotation animation.
    //
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        presentationWrappingView?.clipsToBounds = true
        presentationWrappingView?.layer.shadowOpacity = 0
        presentationWrappingView?.layer.shadowRadius = 0
        
        coordinator.animate(alongsideTransition: { (_) in
            
        }) { (_) in
            self.presentationWrappingView?.clipsToBounds = false
            self.presentationWrappingView?.layer.shadowOpacity = 0.63
            self.presentationWrappingView?.layer.shadowRadius = 17
        }
    }
    
    //| ----------------------------------------------------------------------------
    //  When the presentation controller receives a
    //  -viewWillTransitionToSize:withTransitionCoordinator: message it calls this
    //  method to retrieve the new size for the presentedViewController's view.
    //  The presentation controller then sends a
    //  -viewWillTransitionToSize:withTransitionCoordinator: message to the
    //  presentedViewController with this size as the first argument.
    //
    //  Note that it is up to the presentation controller to adjust the frame
    //  of the presented view controller's view to match this promised size.
    //  We do this in -containerViewWillLayoutSubviews.
    //
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let container = container as? UIViewController, container == presentedViewController {
            return CGSize(width: parentSize.width / 2, height: parentSize.height / 2)
        }
        return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds = containerView!.bounds
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        
        // Center the presentationWrappingView view within the container.
        let frame = CGRect(x: containerViewBounds.midX - presentedViewContentSize.width / 2, y: containerViewBounds.midY - presentedViewContentSize.height / 2, width: presentedViewContentSize.width, height: presentedViewContentSize.height)
        
        // Outset the centered frame of presentationWrappingView so that the
        // dismiss button is within the bounds of presentationWrappingView.
        return frame.insetBy(dx: -20, dy: -20)
    }
    
    //| ----------------------------------------------------------------------------
    //  This method is similar to the -viewWillLayoutSubviews method in
    //  UIViewController.  It allows the presentation controller to alter the
    //  layout of any custom views it manages.
    //
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        if let presentationWrappingView = presentationWrappingView {
            presentationWrappingView.frame = frameOfPresentedViewInContainerView
            
            // Undo the outset that was applied in -frameOfPresentedViewInContainerView.
            presentedViewController.view.frame = presentationWrappingView.bounds.insetBy(dx: 20, dy: 20)
            
            // Position the dismissButton above the top-left corner of the presented
            // view controller's view.
            dismissButton?.center = CGPoint(x: presentedViewController.view.frame.minX, y: presentedViewController.view.frame.minY)
        }
    }
    
    //MARK:- Actions
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Utils
    private func configureCustomViews() {
        let presentedViewControllerView = initPresentedViewControllerView()
        
        let presentationWrapperView = initPresentatioWrapperView()
        self.presentationWrappingView = presentationWrapperView
        
        presentationWrapperView.addSubview(presentedViewControllerView)
        
        let dismissButton = initDismissButton()
        self.dismissButton = dismissButton
        presentationWrapperView.addSubview(dismissButton)
    }
    
    private func initPresentatioWrapperView() -> UIView {
        let view = UIView()
        view.layer.shadowOpacity = 0.63
        view.layer.shadowRadius = 17
        return view
    }
    
    private func initPresentedViewControllerView() -> UIView {
        let view = super.presentedView!
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }
    
    private func initDismissButton() -> UIButton {
        let view = UIButton(type: .custom)
        view.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        view.setImage(UIImage(named: "CloseButton"), for: .normal)
        view.addTarget(self, action: #selector(dismissButtonTapped(_ :)), for: .touchUpInside)
        return view
    }
}
