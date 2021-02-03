
//
//  RepoDescriptionViewModel.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

///VM for VC with info about description of repository
class RepoDescriptionViewModel: AccountByLoginRequestObserver{
    var id: Int = 1
    
    lazy var repos: Results<RepoStoragable> = { realm.objects(RepoStoragable.self) }()
    private var repoToStorage = RepoStoragable()
    var repo: BehaviorSubject<RepoStoragable>!
    var isFavorites: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    
    init(){
        AccountRequestManager.shared.attach(self)
        repo = BehaviorSubject(value: repoToStorage)
    }
    
    //AccountByLoginRequestObserver method
    func update(user: UserByLogin) {
        repoToStorage.addInfo(from: user)
        repo.onNext(repoToStorage)
    }
    
    ///Update repository local instance with new data
    ///
    /// - Parameters:
    ///   - data:   repo with updated info
    func updateRepo(data: Repo) {
        isFavorites.onNext(realm.objects(RepoStoragable.self).contains(where: {$0.id==data.id}))
        var favorite = false
        do{
            try favorite = isFavorites.value()
        } catch{
            print(error.localizedDescription)
        }
        if favorite{
            repoToStorage = realm.objects(RepoStoragable.self).first(where: {$0.id == data.id})!
            repo.onNext(repoToStorage)
        } else{
            repoToStorage.addInfo(from: data)
            AccountRequestManager.shared.getUserByLogin(login: data.owner.login)
        }
    }
    
    ///Save repository in local database
    func saveRepo(){
        do{
            try realm.write() {
                realm.add(repoToStorage)
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    ///Delete repository from local database
    func deleteRepo(){
        do{
            try realm.write() {
                realm.delete(repoToStorage)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}

