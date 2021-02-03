//
//  ReposListViewModel.swift
//  GithubAssistant
//
//  Created by user166683 on 1/23/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

///Protocol that describe view model for  VC with table with repos
protocol ReposListVMProtocol{
    ///Collection of repository
    var repos: PublishSubject<[Repo]> {get set}
    ///Indicator of loading process
    var showLoading: BehaviorRelay<Bool>{get}
    ///Title for VC
    var title: String {get}
    
    ///Some logic for search concrete repository
    ///
    /// - Parameters:
    ///   - name:   name of searched repository
    func searchRepos(by name: String)
    ///Some logic to update collection of repository
    func updateRepos()
}

///VM for VC with functional of search repository in network
class  SearchReposViewModel: ReposListVMProtocol, RepoRequestObserver {
    var id: Int = 1    
    
    var repos: PublishSubject<[Repo]> = PublishSubject<[Repo]>()
    var showLoading = BehaviorRelay<Bool>(value: true)    
    var title: String = "Search repository"
    
    init(){
        RepoRequestManager.shared.attach(self)
    }
    
    func searchRepos(by name: String) {
        showLoading.accept(false)
        RepoRequestManager.shared.updateReposBy(name: name)
    }
    
    func updateRepo(data: Repos) {
        repos.onNext(data.repos)
        showLoading.accept(true)
    }
    
    func updateRepos(){
        
    }
}

///VM for VC with functional of show stored repositories from local databse
class  StoredReposViewModel: ReposListVMProtocol {
    var repos: PublishSubject<[Repo]> = PublishSubject<[Repo]>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    var title: String = "Favored repository"
    
    init(){
        updateRepos()
    }
    
    func updateRepos(){
        repos.onNext(realm.objects(RepoStoragable.self).map({$0.transformToRepo()}))
    }
    
    func searchRepos(by name: String) {
        repos.onNext(realm.objects(RepoStoragable.self).map({$0.transformToRepo()}).filter({$0.fullName.contains(name)}))
    }
}
