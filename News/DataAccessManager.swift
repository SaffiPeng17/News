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
import RealmSwift
import Kingfisher

class DataAccessManager {
    
    static let shared = DataAccessManager()

    private let realmDAO = RealmDAO()
    private let apiProvider = MoyaProvider<ApiService>()
    private let downloadImageQueue = DispatchQueue.global(qos: .background)
    
    private var disposeBag = DisposeBag()

    let newsUpdated = PublishRelay<[Article]>()
    
    var newsData = [Article]()
    
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
                    self.dataHandler(articles: data.articles)
                } catch {
                    LogHelper.print(.api, item: "parse response failed")
                }

            case .failure:
                LogHelper.print(.api, item: "fetch topHeadLines failed")
            }
        }
    }
    
    private func dataHandler(articles: [Article]) {
        self.storeArticles(articles)
        self.downloadImages(imageURLs: articles.compactMap { $0.urlToImage })
    }
}

// MARK: - PRIVATE methods
private extension DataAccessManager {
    // store API data to Realm
    func storeArticles(_ articles: [Article]) {
        guard articles.count > 0 else {
            return
        }
        let rlmArticles = articles.compactMap { RLMTopHeadArticle(with: $0) }
        self.realmDAO.update(rlmArticles)
    }
    
    // download images in articles
    private func downloadImages(imageURLs: [String]) {
        downloadImageQueue.async {
            imageURLs.forEach { urlString in
                self.downloadImage(urlString: urlString, completionHandler: nil)
            }
        }
    }

    // image download
    private func downloadImage(urlString: String, progressBlock: DownloadProgressBlock? = nil, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) {
        guard let url = URL(string: urlString) else {
            return
        }
        LogHelper.print(.download, item: "image from: ", urlString)
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}
