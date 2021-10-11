//
//  TopHeadLinesModel.swift
//  News
//
//  Created by Saffi on 2021/10/10.
//

import Foundation

struct TopHeadLinesModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status, totalResults, articles
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        status = try values.decode(String.self, forKey: .status)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
        articles = try values.decode([Article].self, forKey: .articles)
    }
}

struct Article: Codable {
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        source = try values.decode(Source.self, forKey: .source)
        author = try values.decodeIfPresent(String.self, forKey: .author) ?? ""
        title = try values.decode(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        url = try values.decode(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage) ?? ""
        publishedAt = try values.decode(String.self, forKey: .publishedAt)
        content = try values.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
    
    init(source: Source, author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

struct Source: Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decode(String.self, forKey: .name)
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
