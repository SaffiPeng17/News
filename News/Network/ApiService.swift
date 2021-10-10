//
//  ApiService.swift
//  News
//
//  Created by Saffi on 2021/10/10.
//

import Foundation
import Moya

enum ApiService {
    case topHeadLines(country: String)
}

// MARK: - TargetType, implement for MoyaProvider
extension ApiService: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org")!
    }
    
    var path: String {
        switch self {
        case .topHeadLines:
            return "/v2/top-headlines"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .topHeadLines:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .topHeadLines(let country):
            return .requestParameters(parameters: ["country": country, "apiKey": AppConfig.API.key],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
