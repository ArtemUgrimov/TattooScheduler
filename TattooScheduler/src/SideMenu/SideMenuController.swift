//
//  SideMenuController.swift
//  TattooScheduler
//
//  Created by Artem on 25.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class SideMenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowSettings"), object: nil)
        default: break
        }
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
}
