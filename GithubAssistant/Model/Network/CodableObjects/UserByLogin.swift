//
//  UserByLogin.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

// MARK: - UserByLogin
struct UserByLogin: Codable {
    let login: String
    let id: Int
    let url: String
    let name: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case url
        case name, email
    }
}
