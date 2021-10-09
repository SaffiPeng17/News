//
//  DataAccessManager.swift
//  News
//
//  Created by Saffi on 2021/10/9.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Kingfisher
import Alamofire

class DataAccessManager {
    
    static let shared = DataAccessManager()
    
    private(set) var disposeBag = DisposeBag()

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
    
    func fetchNews() {
        // TODO: fetch news from API
    }
}

// MARK: - Realm data control
extension DataAccessManager {
    func storeNews() {
        // TODO: store API news to Realm
    }
    
    func getNews() {
        // TODO: get news from Realm
    }
}
