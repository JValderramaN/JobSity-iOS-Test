//
//  ShowViewModel.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 18/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation
import Moya

// MARK: - Service configuration

enum ShowServices {
    case listShows(page: Int)
    case searchShows(query: String)
    case showDetail(_ showID: Int)
}

extension ShowServices: TargetType {
    var baseURL: URL {
        return apiBaseURL
    }
    
    var path: String {
        switch self {
        case .listShows: return "shows"
        case .searchShows: return "search/shows"
        case .showDetail(let showID): return "shows/\(showID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listShows, .searchShows, .showDetail:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .listShows, .searchShows, .showDetail:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .listShows(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        case .searchShows(let query):
            return .requestParameters(parameters: ["q" : query], encoding: URLEncoding.queryString)
        case .showDetail:
            return .requestParameters(parameters: ["embed" : "episodes"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

// MARK: - ViewModel configuration

class ShowViewModel: APIRequestable {
    
    static let maxResult: Float = 250
    typealias Service = ShowServices
    lazy var provider: MoyaProvider<ShowServices> = MoyaProvider<ShowServices>()
    
    func getShows(by query: String, callback: @escaping ([Show]?, Error?) -> Void) {
        request(target: .searchShows(query: query), model: [ShowWrapper].self) { (wrappedShows, error) in
            let shows = wrappedShows?.compactMap { $0.show }
            callback(shows, error)
        }
    }
    
    func getShows(by page: Int = 0, callback: @escaping ([Show]?, Error?) -> Void) {
        request(target: .listShows(page: page), model: [Show].self) { (shows, error) in
            callback(shows, error)
        }
    }
    
    func getShowDetail(_ showID: Int, callback: @escaping (Show?, Error?) -> Void) {
        request(target: .showDetail(showID), model: Show.self) { (show, error) in
            callback(show, error)
        }        
    }
    
}
