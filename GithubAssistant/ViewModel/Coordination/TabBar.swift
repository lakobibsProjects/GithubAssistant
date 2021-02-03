//
//  TabBar.swift
//  GithubAssistant
//
//  Created by user166683 on 1/25/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit

///Main tab bar for navigation
class TabBar: UITabBarController, UITabBarControllerDelegate {
    let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
    let favoritesCoordinator = StoredCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCoordinator.start()
        favoritesCoordinator.start()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let controllers = [searchCoordinator.navigationController, favoritesCoordinator.navigationController]
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}
