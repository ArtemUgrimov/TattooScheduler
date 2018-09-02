//
//  MainViewSideStuff.swift
//  TattooScheduler
//
//  Created by Artem on 25.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    @IBAction func onMoreTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func showProfile() {
        performSegue(withIdentifier: "ShowProfile", sender: nil)
    }
    
    @objc func showSettings() {
        performSegue(withIdentifier: "ShowSettings", sender: nil)
    }
}
