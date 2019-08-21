//
//  Show.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 18/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation

struct ShowWrapper: Model {
    var show: Show
}

struct Show: Model {
    
    struct ShowSchedule: Model, CustomStringConvertible {
        var time: String
        var days: [String]
        
        var description: String {
            let days = self.days.joinedWithCommas
            return "\(time): \(days)"
        }
        
    }
    
    var id: Int
    var name: String
    var image: URL?
    var schedule: ShowSchedule
    var genres: [String]
    var summary: String?
    var episodes: [Episode]?
    
    var episodesBySeason: [Int: [Episode]] {
        guard let episodes = episodes else { return [:] }
        return Dictionary(grouping: episodes) { $0.season }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, summary, schedule, genres
        case episodes = "_embedded"
    }
    
    enum ImageCodingKey: CodingKey {
        case medium
    }
    
    enum EmbeddedCodingKey: CodingKey {
        case episodes
    }
    
    init(id: Int,
         name: String,
         image: URL?,
         schedule: ShowSchedule,
         genres: [String],
         summary: String?,
         episodes: [Episode]?) {
        self.id = id
        self.name = name
        self.image = image
        self.schedule = schedule
        self.genres = genres
        self.summary = summary
        self.episodes = episodes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        schedule = try container.decode(ShowSchedule.self, forKey: .schedule)
        summary = try? container.decode(String.self, forKey: .summary)
        genres = try container.decode([String].self, forKey: .genres)
        
        if let imageInfo = try? container.nestedContainer(keyedBy: ImageCodingKey.self, forKey: .image),
            let imageUrlString = try? imageInfo.decode(String.self, forKey: .medium) {
            image = URL(string: imageUrlString)
        }
        
        if let embeddedInfo = try? container.nestedContainer(keyedBy: EmbeddedCodingKey.self, forKey: .episodes) {
            episodes = try? embeddedInfo.decode([Episode].self, forKey: .episodes)
        }
        
    }
    
}

// MARK: - Hashable

extension Show: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Show, rhs: Show) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: - SimpleDataSourceExposable

extension Show: SimpleDataSourceExposable {
    
    var url: URL? { return image }
    var text: String? { return name }
    
}
