//
//  RepoDescViewController.swift
//  GithubAssistant
//
//  Created by user166683 on 1/25/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

///VC for description of repository
class RepoDescViewController: UIViewController {
    weak var coordinator: Coordinator?
    var vm: RepoDescriptionViewModel?
    private let disposeBag = DisposeBag()
    
    var topView: UIView!//to remove?
    
    var contentView: UIView!
    var nameLabel: UILabel!
    var descTabLabel: UILabel!
    var descriptionLabel: UILabel!
    var ownerLabel: UILabel!
    var emailLabel: UILabel!
    
    //MARK: - Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Support Functions
    ///setup all views
    private func setupVC(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    ///initialization and set default state for view and each subview
    private func initViews(){
        self.view.backgroundColor = .lightGray
        
        topView = UIView()
        
        contentView =  UIView()
        nameLabel = UILabel()
        nameLabel.sizeToFit()
        nameLabel.numberOfLines = 0        
        descTabLabel = UILabel()
        descTabLabel.text = "Description:"
        descriptionLabel = UILabel()
        descriptionLabel.sizeToFit()
        descriptionLabel.numberOfLines = 0
        ownerLabel = UILabel()
        emailLabel = UILabel()
        vm?.repo.asObservable().map({"Repository name: \($0.repoName)"}).bind(to: self.nameLabel.rx.text)
        vm?.repo.asObservable().map({$0.repoDescription}).bind(to: self.descriptionLabel.rx.text)
        vm?.repo.asObservable().map({"Owner: \($0.ownerName)"}).bind(to: self.ownerLabel.rx.text)
        vm?.repo.asObservable().map({"E-mail: \($0.ownerEmail)"}).bind(to: self.emailLabel.rx.text)
        
        let toFavotireButton = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(toFavorites))
        let removeFromFavotireButton = UIBarButtonItem(title: "remove", style: .plain, target: self, action: #selector(removeFromFavorites))
        self.navigationItem.rightBarButtonItems = [removeFromFavotireButton, toFavotireButton]
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal)
        backbutton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    
    //MARK: - Event Handlers
    @objc private func toFavorites(){
        vm?.saveRepo()
    }
    
    @objc private func removeFromFavorites(){
        vm?.deleteRepo()
    }
    
    @objc private func popToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Layout
extension RepoDescViewController{
    ///setup hierarchy of views
    private func setupViews(){
        self.view.addSubview(topView)
        self.view.addSubview(contentView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(descTabLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    ///set constraints for all views
    private func setupConstraints(){
        topView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(96)
            $0.height.equalTo(32)
        })
        
        contentView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
            $0.top.equalToSuperview().inset(144)
        })
        
        nameLabel.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            $0.height.greaterThanOrEqualTo(32)
        })
        
        ownerLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.height.equalTo(32)
        })
        
        emailLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(ownerLabel.snp.bottom).offset(8)
            $0.height.equalTo(32)
        })
        
        descTabLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.height.equalTo(32)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descTabLabel.snp.bottom).offset(8)
            $0.height.greaterThanOrEqualTo(32)
        })
    }
}
