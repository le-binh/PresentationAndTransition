//
//  CustomPresentationSecondViewController.swift
//  PresentationAndTransition
//
//  Created by Le Van Binh on 1/18/17.
//  Copyright © 2017 Le Van Binh. All rights reserved.
//

import UIKit

class CustomPresentationSecondViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize(with: traitCollection)
    }
    
    // When we rotate the device, we need to update preferredContentSize
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSize(with: newCollection)
    }
    
    @IBAction func unwindToCustomPresentationSecondViewController(segue: UIStoryboardSegue) {}
    
    //| --------------------------------------------------------------------------------------------
    //  When we change view controller's preferredContentSize, -preferredContentSizeDidChangeForChildContentContainer
    //  in presentation controller is triggered
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        preferredContentSize = CGSize(width: view.bounds.size.width, height: CGFloat(sender.value))
    }
    
    func updatePreferredContentSize(with traitCollection: UITraitCollection) {
        let width = view.bounds.size.width
        let height: CGFloat = traitCollection.verticalSizeClass == .compact ? 270 : 420
        preferredContentSize = CGSize(width: width, height: height)
        
        slider.maximumValue = Float(height)
        slider.minimumValue = 220
        slider.value = slider.maximumValue
    }
}
