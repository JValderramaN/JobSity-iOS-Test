//
//  APIRequest.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 18/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation
import Moya

let apiBaseURL = URL(string: "http://api.tvmaze.com/")!

protocol APIRequestable {
    associatedtype Service: TargetType
    var provider: MoyaProvider<Service> { get }
}

extension APIRequestable {
    
    func request<T>(target: Service,
                    model: T.Type,
                    completion: @escaping ((T?, Error?) -> Void)) where T : Decodable {
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let modelDecoded = try decoder.decode(model.self, from: response.data)
                    completion(modelDecoded, nil)
                } catch {
                    completion(nil, error)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
}
