//
//  Coordinator.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit

///Coordinator that describe logic of segeues in tab with table
protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    ///Initiate navigation with root VC
    func start()
    
    ///Segeue to description of repository
    ///
    /// - Parameters:
    ///   - repo:   described repo
    func toDescription(of repo: Repo)
}
