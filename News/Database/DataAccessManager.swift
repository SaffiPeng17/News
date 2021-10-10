//
//  DataAccessManager.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
//import RealmSwift
//import Kingfisher

class DataAccessManager {
    
    static let shared = DataAccessManager()
    private let apiProvider = MoyaProvider<ApiService>()
    
    private var disposeBag = DisposeBag()

    let newsUpdated = PublishSubject<[NewsCellModel]>()
    
    var newsData = [NewsCellModel]()
    
    private init() {
        
    }

    func release() {
        self.disposeBag = DisposeBag()
    }
}

// MARK: - fetch API data
extension DataAccessManager {
    func fetchTopHeadLines() {
        self.apiProvider.request(.topHeadLines(country: "us")) { [unowned self] result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(TopHeadLinesModel.self, from: response.data)
                    self.storeTopHeadLines(data: data.articles)
                } catch {
                    LogHelper.print(.api, item: "parse response failed")
                }

            case .failure:
                LogHelper.print(.api, item: "fetch topHeadLines failed")
            }
        }
    }
}

// MARK: - Realm data control
extension DataAccessManager {
    func storeTopHeadLines(data: [Article]) {
        // TODO: store API news to Realm
    }
    
    func getNews() {
        // TODO: get news from Realm
    }
}
