//
//  PeopleViewModel.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 19/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation
import Moya

// MARK: - Service configuration

enum PersonServices {
    case searchPeople(query: String)
    case personDetail(personID: Int)
}

extension PersonServices: TargetType {
    var baseURL: URL {
        return apiBaseURL
    }
    
    var path: String {
        switch self {
        case .searchPeople: return "search/people"
        case .personDetail(let personID): return "people/\(personID)/castcredits"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPeople, .personDetail:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .searchPeople, .personDetail:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .searchPeople(let query):
            return .requestParameters(parameters: ["q" : query], encoding: URLEncoding.queryString)
        case .personDetail:
            return .requestParameters(parameters: ["embed" : "show"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }    
    
}

// MARK: - ViewModel configuration

class PeopleViewModel: APIRequestable {
    
    typealias Service = PersonServices
    lazy var provider: MoyaProvider<PersonServices> = MoyaProvider<PersonServices>()
    
    func getPeople(by query: String, callback: @escaping ([Person]?, Error?) -> Void) {
        request(target: .searchPeople(query: query), model: [PersonWrapper].self) { (wrappedPeople, error) in
            let people = wrappedPeople?.compactMap { $0.person }
            callback(people, error)
        }
    }
    
    func getPersonDetail(_ personID: Int, callback: @escaping ([Show]?, Error?) -> Void) {
        request(target: .personDetail(personID: personID), model: [PersonCastShowWrapper].self) { (wrappedShows, error) in
            let shows = wrappedShows?.compactMap { $0.show }
            callback(shows, error)
        }
    }
    
}
