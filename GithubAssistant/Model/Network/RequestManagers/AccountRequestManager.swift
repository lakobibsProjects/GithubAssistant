//
//  AccountRequestManager.swift
//  GithubAssistant
//
//  Created by user166683 on 1/22/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import Alamofire

///Request user and send to subscribers
class AccountRequestManager{
    let dafaultBeginURL = "https://api.github.com"
    let searchForNameMiddleURL = "/users/"
    var userResponse: UserByLogin?
    
    //singleton
    private init(){
        
    }
    
    static var shared: AccountRequestManager = {
        let instance = AccountRequestManager()
        return instance
    }()
    
    ///Find user and notify
    ///
    /// - Parameters:
    ///   - login:   login of searched user
    func getUserByLogin(login: String) {
        let urlString = "https://api.github.com/users/\(login)"
        let request =  AF.request(urlString)
        request.responseDecodable(of: UserByLogin.self) { (response) in
            print(response.error?.localizedDescription ?? "")
            guard let response = response.value else {
                print("fail to response user of url: \(urlString)")                
                let dialogMessage = UIAlertController(title: "", message: "Somthing wrong in interaction with server when request info about user" , preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                dialogMessage.addAction(ok)
                UIApplication.shared.windows.last?.rootViewController?.present(dialogMessage, animated: true)
                return }
            self.userResponse = response
            self.notify(user: response)
        }
    }
    
    //observerPattern
    var state: Int = { return Int(arc4random_uniform(10)) }()
    
    private lazy var observers = [AccountByLoginRequestObserver]()
    
    func attach(_ observer: AccountByLoginRequestObserver) {
        observers.append(observer)
    }
    
    func detach(_ observer: AccountByLoginRequestObserver) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func notify(user: UserByLogin) {
        observers.forEach({ $0.update(user: user)})
    }
    
}
