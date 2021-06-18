//
//  TabBarController.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 14/6/21.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ajustes", style: .plain, target: self, action: #selector(ajustes))
    }
    
    @objc func ajustes() {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ajustes")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

