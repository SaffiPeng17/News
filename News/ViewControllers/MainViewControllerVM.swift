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
    
    let reloadCell = PublishRelay<Void>()
    
    let dataManager = DataAccessManager.shared
    var newsCellVMs = [NewsCellVM]()

    override init() {
        super.init()
        self.getNewsData()
        self.initBinding()
    }
    
    private func getNewsData() {
        self.dataManager.fetchTopHeadLines()
    }

    private func initBinding() {
        // TODO: 訂閱dataManager資料
        self.dataManager.newsUpdated.subscribe { models in
            self.reloadCell.accept(())
        }.disposed(by: self.disposeBag)

    }
}

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
