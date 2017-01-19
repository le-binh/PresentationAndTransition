//
//  CustomPresentationController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

private let cornerRadius: CGFloat = 20
class CustomPresentationController: UIPresentationController {
    
    private var dimmingView: UIView?
    private var presentationWrappingView: UIView?
    
    //MARK:- LifeCycle
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        configureCustomViews()
        animateDimmingPresentation()
    }
    
    override func dismissalTransitionWillBegin() {
        animateDimmingDismissal()
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView = nil
            presentationWrappingView = nil
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView = nil
            presentationWrappingView = nil
        }
    }
    
    //| ----------------------------------------------------------------------------------------------------------------
    //  Return -presentationWrappingView as the -presentedView.
    //  -presentedView is added later (by the animator), so any custom views added will appear behind the -presentedView
    override var presentedView: UIView? {
        return presentationWrappingView
    }
    
    //MARK:- Layout
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds = containerView?.bounds ?? CGRect.zero
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        var presentedViewControllerFrame = containerViewBounds
        
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        presentedViewControllerFrame.size.width = containerViewBounds.size.width - 2 * cornerRadius
        presentedViewControllerFrame.origin.x = cornerRadius
        presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height - cornerRadius
        return presentedViewControllerFrame
    }
    
    //| ---------------------------------------------------------------------------------------------------------------------
    //  This method is invoked when the presentedViewController's preferredContentSize property changes.
    //  It is also invoked just before the presentation transition begins (prior to -presentationTransitionWillBegin)
    //
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if let container = container as? UIViewController, container == presentedViewController {
            // Adjust containerView's subviews during the next update cycle.
            // We change the presentedView's frame in the -containerViewWillLayoutSubviews.
            containerView?.setNeedsLayout()
        }
    }
    
    //| ---------------------------------------------------------------------------------------------------------------------
    //  When the presentation controller receives a -viewWillTransitionToSize:withTransitionCoordinator: message, it calls 
    //  this method to retrieve the new size for the presentedViewController's view.
    //
    //  The presentation controller then sends a -viewWillTransitionToSize:withTransitionCoordinator: message to the 
    //  presentedViewController with this size as the first argument.
    //
    //  Note that it is up to the presentation controller to adjust the frame of the presented view controller's view to match
    //  this promised size. We do this in -containerViewWillLayoutSubviews.
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let container = container as? UIViewController, container == presentedViewController {
            return container.preferredContentSize
        }
        return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }
    
    //| ----------------------------------------------------------------------------------------------------------------------
    //  THis method is similar to the -viewWillLayoutSubviews method in the UIViewController.
    //  It allows the presentation controller to alter the layout of any custom views it changes.
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? CGRect.zero
        presentationWrappingView?.frame = frameOfPresentedViewInContainerView
    }
    
    //MARK:- Tap gesture recognizer
    func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Utils
    private func configureCustomViews() {
        configurePresentationWrappingView()
        configureDimmingView()
    }
    
    private func configureDimmingView() {
        let dimmingView = UIView(frame: containerView!.bounds)
        dimmingView.alpha = 0
        dimmingView.isOpaque = false
        dimmingView.backgroundColor = UIColor.black
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
        containerView?.addSubview(dimmingView)
        self.dimmingView = dimmingView
    }
    
    // Wrap the presented view controller's view in an intermediate hierarchy
    // that applies a shadow and rounded corners to the top-left and top-right
    // edges.  The final effect is built using three intermediate views.
    //
    // presentationWrapperView              <- shadow
    //   |- presentationRoundedCornerView   <- rounded corners (masksToBounds)
    //        |- presentedViewControllerWrapperView
    //             |- presentedViewControllerView (presentedViewController.view)
    private func configurePresentationWrappingView() {
        let presentedViewControllerView = super.presentedView
        
        let presentationWrapperView = initPresentationWrapperView(frame: frameOfPresentedViewInContainerView)
        self.presentationWrappingView = presentationWrapperView
        
        let presentationRoundedCornerView = initPresentationRoundedCornerView(frame: presentationWrapperView.bounds)
        
        let presentedViewControllerWrapperView = initPresentedViewControllerWrapperView(frame: presentationRoundedCornerView.bounds)
        
        presentedViewControllerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        presentedViewControllerView?.frame = presentedViewControllerWrapperView.bounds
        presentedViewControllerWrapperView.addSubview(presentedViewControllerView!)
        
        presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
        
        presentationWrapperView.addSubview(presentationRoundedCornerView)
    }
    
    //| --------------------------------------------------------------------------------------------------------------
    // presentationRoundedCornerView is CORNER_RADIUS points taller than the
    // height of the presented view controller's view.  This is because
    // the cornerRadius is applied to all corners of the view.  Since the
    // effect calls for only the top two corners to be rounded we size
    // the view such that the bottom CORNER_RADIUS points lie below
    // the bottom edge of the screen.
    //
    private func initPresentationRoundedCornerView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }
    
    private func initPresentedViewControllerWrapperView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }
    
    private func initPresentationWrapperView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.layer.shadowOpacity = 0.44
        view.layer.shadowRadius = 13
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        return view
    }
    
    private func animateDimmingPresentation() {
        let transitionCoordinator = presentedViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView?.alpha = 0.5
        }, completion: nil)
    }
    
    private func animateDimmingDismissal() {
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView?.alpha = 0
        }, completion: nil)
    }
}
