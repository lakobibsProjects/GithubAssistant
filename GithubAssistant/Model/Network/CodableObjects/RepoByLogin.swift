//
//  RepoByLogin.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

// MARK: - Repos
struct Repos: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let repos: [Repo]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repos = "items"
    }
}

// MARK: - Item
struct Repo: Codable {
    let id: Int
    let name, fullName: String
    let itemPrivate: Bool
    let owner: Owner
    let htmlURL: String
    let itemDescription: String?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case itemPrivate = "private"
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case url
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case login, id
    }
}

