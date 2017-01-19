//
//  AdaptivePresentationFirstViewController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/19/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class AdaptivePresentationFirstViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionation = segue.destination
        destionation.modalPresentationStyle = .custom
        destionation.transitioningDelegate = self
    }
}

extension AdaptivePresentationFirstViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AdaptivePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
