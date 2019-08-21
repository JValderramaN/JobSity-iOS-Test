//
//  Episode.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 18/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation

struct Episode: Model {
    
    var id: Int
    var name: String
    var number: Int
    var season: Int
    var summary: String?
    var image: URL?
    
    enum CodingKeys: CodingKey {
        case id, name, number, season, summary, image
    }
    
    enum ImageCodingKey: CodingKey {
        case medium
    }
    
    init(id: Int,
         name: String,
         number: Int,
         season: Int,
         summary: String?,
         image: URL?) {
        self.id = id
        self.name = name
        self.number = number
        self.season = season
        self.summary = summary
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(Int.self, forKey: .number)
        season = try container.decode(Int.self, forKey: .season)
        summary = try? container.decode(String.self, forKey: .summary)
        if let imageInfo = try? container.nestedContainer(keyedBy: ImageCodingKey.self, forKey: .image),
            let imageUrlString = try? imageInfo.decode(String.self, forKey: .medium) {
            image = URL(string: imageUrlString)
        }
    }
    
}

// MARK: - Hashable

extension Episode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: - SimpleDataSourceExposable

extension Episode: SimpleDataSourceExposable {
    
    var url: URL? { return image }
    var text: String? { return "\(number)" }
    
}
