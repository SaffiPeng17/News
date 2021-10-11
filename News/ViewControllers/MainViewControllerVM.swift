//
//  MainViewControllerVM.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewControllerVM: BaseViewModel {

    var disposeBag = DisposeBag()
    
    let reloadTable = PublishRelay<Void>()
    
    let dataManager = DataAccessManager.shared
    var newsCellVMs = [NewsCellVM]()

    override init() {
        super.init()
        self.getTopHeadLines()
        self.initBinding()
    }
    
    private func getTopHeadLines() {
        self.dataManager.fetchTopHeadLines()
    }

    private func initBinding() {
        self.dataManager.articlesUpdated.subscribe(onNext: { [unowned self] articles in
            self.updateNewsCells(with: articles)
            self.reloadTable.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    private func updateNewsCells(with articles: [Article]) {
        self.newsCellVMs = articles.map { NewsCellVM(with: $0) }
    }
}

// MARK: - tableView dataSource
extension MainViewControllerVM {
    func numberOfRows() -> Int {
        return self.newsCellVMs.count
    }
    
    func getNewsCellVM(indexPath: IndexPath) -> NewsCellVM? {
        guard indexPath.row < self.newsCellVMs.count else {
            return nil
        }
        return self.newsCellVMs[indexPath.row]
    }
}
