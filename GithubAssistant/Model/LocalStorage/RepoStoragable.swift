//
//  RepoStoragable.swift
//  GithubAssistant
//
//  Created by user166683 on 1/25/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import RealmSwift

///Repository class for store in local DB
class RepoStoragable: Object{
    @objc dynamic var id = 0
    @objc dynamic var repoName = ""
    @objc dynamic var ownerName = ""
    @objc dynamic var ownerLogin = ""
    @objc dynamic var ownerEmail = ""
    @objc dynamic var repoDescription = ""
    
    override init(){
        super.init()
    }
    
    init(id: Int, repoName: String, ownerName: String, ownerEmail: String, repoDescription: String){
        self.id = id
        self.repoName = repoName
        self.ownerName = ownerName
        self.ownerEmail = ownerEmail
        self.repoDescription = repoDescription
    }
    
    ////Update fields
    ///
    /// - Parameters:
    ///   - from:   info about repository
    func addInfo(from repo: Repo){
        self.repoName = repo.fullName
        self.id = repo.id
        self.repoDescription = repo.itemDescription ?? ""
    }
    
    ///Update fields
    ///
    /// - Parameters:
    ///   - from:   info about owner
    func addInfo(from user: UserByLogin){
        self.ownerEmail = user.email ?? ""
        self.ownerName = user.name ?? ""
        self.ownerLogin = user.login
    }
    
    ///Convert storagable repository to codable class of repository
    ///
    /// - Returns: instance of repository like download from network
    func transformToRepo() -> Repo{
        return Repo(id: id, name: "", fullName: repoName, itemPrivate: false, owner: Owner(login: ownerLogin, id: -1), htmlURL: "", itemDescription: repoDescription, url: "")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
