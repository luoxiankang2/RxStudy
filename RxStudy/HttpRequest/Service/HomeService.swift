//
//  HomeService.swift
//  RxStudy
//
//  Created by season on 2021/5/20.
//  Copyright © 2021 season. All rights reserved.
//

import Foundation

import Moya

enum HomeService {
    case banner

    case topArticle

    case normalArticle(_ page: Int)
    
    case hotKey

    case queryKeyword(_ keyword: String, _ page: Int)
}


extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: Api.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .banner:
            return Api.Home.banner
        case .topArticle:
            return Api.Home.topArticle
        case .normalArticle(let page):
            return Api.Home.normalArticle + page.toString + "/json"
        case .hotKey:
            return Api.Home.hotKey
        case .queryKeyword(_, let page):
            return Api.Home.queryKeyword + page.toString + "/json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .queryKeyword:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .banner:
            return .requestParameters(parameters: Dictionary.empty, encoding: URLEncoding.default)
        case .topArticle:
            return .requestParameters(parameters: Dictionary.empty, encoding: URLEncoding.default)
        case .normalArticle(_):
            return .requestParameters(parameters: Dictionary.empty, encoding: URLEncoding.default)
        case .hotKey:
            return .requestParameters(parameters: Dictionary.empty, encoding: URLEncoding.default)
        case .queryKeyword(let keyword, _):
            return .requestParameters(parameters: ["k": keyword], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
