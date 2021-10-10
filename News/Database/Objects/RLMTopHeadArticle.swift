//
//  RLMTopHeadArticle.swift
//  News
//
//  Created by Saffi on 2021/10/10.
//

import Foundation
import RealmSwift

class RLMTopHeadArticle: Object {
    @objc dynamic var sourceID = ""
    @objc dynamic var source = ""
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var desc = "" // description
    @objc dynamic var url = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt = ""
    @objc dynamic var content = ""

    override static func primaryKey() -> String? {
        return "title"
    }

    override static func indexedProperties() -> [String] {
        return ["title", "url", "publishedAt"]
    }
    
    convenience init(with article: Article) {
        self.init()
        self.sourceID = article.source.id
        self.source = article.source.name
        self.author = article.author
        self.title = article.title
        self.desc = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
}
