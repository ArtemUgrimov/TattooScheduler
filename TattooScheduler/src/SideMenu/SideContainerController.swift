//
//  SideContainerController.swift
//  TattooScheduler
//
//  Created by Artem on 25.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class SideContainerController: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    private var closeMenuGesture: UIPanGestureRecognizer!
    private var screenEdgeRecognizer: UIPanGestureRecognizer!
    private var defaultConstraint: CGFloat = -240
    private var sideMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultConstraint = sideMenuConstraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deactivateSideMenu), name: NSNotification.Name("EventOpened"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(activateSideMenu), name: NSNotification.Name("EventClosed"), object: nil)
        
        screenEdgeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(edgeGesture))
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        closeMenuGesture = UIPanGestureRecognizer(target: self, action: #selector(closeGesture))
        closeMenuGesture.isEnabled = false
        view.addGestureRecognizer(closeMenuGesture)
    }
    
    @objc func deactivateSideMenu() {
        closeMenuGesture.isEnabled = false
        screenEdgeRecognizer.isEnabled = false
        if sideMenuVisible {
            sideMenuConstraint.constant = defaultConstraint
        }
        animateMenu()
    }

    @objc func activateSideMenu() {
        closeMenuGesture.isEnabled = false
        screenEdgeRecognizer.isEnabled = true
    }
    
    func animateMenu() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func switchShowAndAnimate() {
        if sideMenuVisible {
            sideMenuConstraint.constant = defaultConstraint
            closeMenuGesture.isEnabled = false
            screenEdgeRecognizer.isEnabled = true
        } else {
            sideMenuConstraint.constant = 0
            closeMenuGesture.isEnabled = true
            screenEdgeRecognizer.isEnabled = false
        }
        
        sideMenuVisible = !sideMenuVisible
        animateMenu()
    }
    
    @objc func toggleSideMenu() {
        switchShowAndAnimate()
    }
    
    @objc func edgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: self.view).x
        let velocity = sender.velocity(in: self.view).x
        
        if sender.state == .changed && translation > 0 && translation < abs(defaultConstraint) {
            sideMenuConstraint.constant = defaultConstraint + translation
        } else if (sender.state == .ended || translation >= abs(defaultConstraint)) && velocity > 0 {
            switchShowAndAnimate()
        } else {
            sideMenuConstraint.constant = defaultConstraint
            animateMenu()
        }
    }
    
    @objc func closeGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view).x
        let velocity = sender.velocity(in: self.view).x
        
        if sender.state == .changed && translation < 0 {
            sideMenuConstraint.constant = translation
        } else if sender.state == .ended && velocity <= 0 {
            switchShowAndAnimate()
        } else {
            sideMenuConstraint.constant = 0
            animateMenu()
        }
    }
}
