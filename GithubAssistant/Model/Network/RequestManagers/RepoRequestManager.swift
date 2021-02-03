//
//  RepoRequestManager.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import Alamofire

///Request repositories and send to subscribers
class RepoRequestManager{
    private let prefixURL = "https://api.github.com/search/repositories?q="
    private let postfixURL = "&page=1&per_page="
    private let reposNumberURL = "150"
    private let thread = DispatchQueue.global(qos: .userInitiated)
    var repoResponse: Repos?
    
    //singleton
    private init(){
        
    }
    
    static var shared: RepoRequestManager = {
        let instance = RepoRequestManager()
        return instance
    }()
    
    ///Update collection of repositories with finded and notify
    ///
    /// - Parameters:
    ///   - name:   name of searched repository
    func updateReposBy(name: String) {
        let urlString = prefixURL + name + postfixURL + reposNumberURL
        thread.async {
            let request =  AF.request(urlString)
            request.responseDecodable(of: Repos.self) { (response) in
                print(response.error?.localizedDescription ?? "")
                guard let response = response.value else {
                    print("fail to response repos.")
                    let dialogMessage = UIAlertController(title: "", message: "Something wrong in interaction with server when request repositories" , preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    dialogMessage.addAction(ok)
                    UIApplication.shared.windows.last?.rootViewController?.present(dialogMessage, animated: true)
                    return }
                DispatchQueue.main.async {
                    self.repoResponse = response
                    self.notify(data: response)
                }
            }
        }
    }
    
    //observer
    private lazy var observers = [RepoRequestObserver]()
    
    func attach(_ observer: RepoRequestObserver) {
        observers.append(observer)
    }
    
    func detach(_ observer: RepoRequestObserver) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func notify(data: Repos) {
        observers.forEach({ $0.updateRepo(data: data)})
    }
    
}
