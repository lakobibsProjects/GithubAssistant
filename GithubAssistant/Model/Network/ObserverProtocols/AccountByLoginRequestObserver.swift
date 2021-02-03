//
//  AccountByLoginRequestObserver.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

protocol AccountByLoginRequestObserver{
    var id: Int {get}
    func update(user: UserByLogin)
}
