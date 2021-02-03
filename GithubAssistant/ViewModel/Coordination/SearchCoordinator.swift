
//
//  MainCoordinator.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

import UIKit

///Segeues for tab with search repo logic
class SearchCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = ReposListViewController.init()
        vc.coordinator = self
        vc.vm = SearchReposViewModel()
        let networkRaposItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        vc.tabBarItem = networkRaposItem
        navigationController.pushViewController(vc, animated: false)
    }
    
    func toDescription(of repo: Repo){
        let vc = RepoDescViewController()
        vc.coordinator = self
        vc.vm = RepoDescriptionViewModel()
        vc.vm?.updateRepo(data: repo)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toDescription(of repo: RepoStoragable) {
        print("not supported")
    }
}

///Segeues for tab with local DB repo logic
class StoredCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = ReposListViewController.init()
        vc.coordinator = self
        vc.vm = StoredReposViewModel()
        let storedReposItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        vc.tabBarItem = storedReposItem
        navigationController.pushViewController(vc, animated: false)
    }
    
    func toDescription(of repo: Repo){
        let vc = RepoDescViewController()
        vc.coordinator = self
        vc.vm = RepoDescriptionViewModel()
        vc.vm?.updateRepo(data: repo)
        navigationController.pushViewController(vc, animated: true)
    }
}
