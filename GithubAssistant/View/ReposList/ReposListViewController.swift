//
//  ReposListViewController.swift
//  GithubAssistant
//
//  Created by user166683 on 1/23/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

///VC for table with repositories
class ReposListViewController: UIViewController {
    weak var coordinator: Coordinator?
    var vm: ReposListVMProtocol!
    private let disposeBag = DisposeBag()
    
    var searchBar: UISearchBar!
    var reposTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    //MARK: - Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm?.updateRepos()
        self.title = vm?.title
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
        self.navigationController?.title = vm.title
        self.view.backgroundColor = .lightGray
        
        searchBar =  UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search repository"
        
        reposTableView = UITableView()
        reposTableView.delegate = self
        reposTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        reposTableView.register(ReposTableViewCell.self, forCellReuseIdentifier: "ReposTableViewCell")
        reposTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.reposTableView.cellForRow(at: indexPath) as! ReposTableViewCell
                if let repo = cell.repo{
                    self!.coordinator?.toDescription(of: repo)
                }
            }).disposed(by: disposeBag)
        
        
        vm.repos.bind(to: reposTableView.rx.items(cellIdentifier: "ReposTableViewCell", cellType: ReposTableViewCell.self)) {  (row,repo,cell) in
            cell.configureCell(with: repo)
        }.disposed(by: disposeBag)
        
        reposTableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
        vm?.showLoading.asObservable().observeOn(MainScheduler.instance).bind(to: activityIndicator.rx.isHidden).disposed(by: disposeBag)
    }
}

//MARK: - Layout
extension ReposListViewController{
    ///setup hierarchy of views
    private func setupViews(){
        self.view.addSubview(searchBar)
        self.view.addSubview(reposTableView)
        
        view.addSubview(activityIndicator)
    }
    
    ///set constraints for all views
    private func setupConstraints(){
        searchBar.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(144)
            $0.height.equalTo(32)
        })
        
        reposTableView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(96)
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
        })
    }
}

//MARK: - UITableViewDelegate & DataSource
extension ReposListViewController: UITableViewDelegate{
    
}

//MARK: - UISearchBarDelegate
extension ReposListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        initiateSearch()
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        initiateSearch()
    }
    
    private func initiateSearch(){
        if let name = searchBar.text{
            vm.searchRepos(by: name)
        }
        self.searchBar.endEditing(true)
    }
}
