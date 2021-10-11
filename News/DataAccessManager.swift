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
    private var topHeadArticlesToken: NotificationToken?

    private let apiProvider = MoyaProvider<ApiService>()
    private let downloadImageQueue = DispatchQueue.global(qos: .background)
    
    private var disposeBag = DisposeBag()

    let articlesUpdated = PublishRelay<[Article]>()
    
    var newsData = [Article]()
    
    private init() {
        self.activeRealmToken()
    }
    
    func activeRealmToken() {
        guard let result = self.realmDAO.read(type: RLMTopHeadArticle.self) else {
            return
        }
        self.topHeadArticlesToken = result.observe { _ in
            let topHeadArticles = Array(result)
            self.parseTopHeadArticle(topHeadArticles)
        }
    }

    deinit {
        self.topHeadArticlesToken?.invalidate()
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
        // preload article images
        self.downloadImages(by: articles.compactMap { $0.urlToImage })
    }
}

// MARK: - Realm controls
private extension DataAccessManager {
    // store API data to Realm
    func storeArticles(_ articles: [Article]) {
        guard articles.count > 0 else {
            return
        }
        let rlmArticles = articles.compactMap { RLMTopHeadArticle(with: $0) }
        self.realmDAO.update(rlmArticles)
    }
    
    func parseTopHeadArticle(_ rlmObject: [RLMTopHeadArticle]) {
        let articles = rlmObject.map { object -> Article in
            let source = Source(id: object.sourceID, name: object.sourceName)
            return Article(source: source,
                           author: object.author,
                           title: object.title,
                           description: object.desc,
                           url: object.url,
                           urlToImage: object.urlToImage,
                           publishedAt: object.publishedAt,
                           content: object.content)
        }
        self.articlesUpdated.accept(articles)
    }
}

// MARK: - download image
private extension DataAccessManager {
    func downloadImages(by imageURLs: [String]) {
        downloadImageQueue.async {
            imageURLs.forEach { urlString in
                self.downloadImage(urlString: urlString, completionHandler: nil)
            }
        }
    }

    func downloadImage(urlString: String, progressBlock: DownloadProgressBlock? = nil, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) {
        guard let url = URL(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}
