//
//  Person.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 19/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation

struct PersonCastShowWrapper: Model {
    var show: Show?
    
    enum CodingKeys: String, CodingKey {
        case show = "_embedded"
    }
    
    enum EmbeddedCodingKey: CodingKey {
        case show
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let embeddedInfo = try? container.nestedContainer(keyedBy: EmbeddedCodingKey.self, forKey: .show),
            let show = try? embeddedInfo.decode(Show.self, forKey: .show) {
            self.show = show
        }
    }
    
}

struct PersonWrapper: Model {
    var person: Person
}

struct Person: Model {
    
    var id: Int
    var name: String
    var image: URL?
    var castShows: [Show]?
    
    enum CodingKeys: CodingKey {
        case id, name, image
    }
    
    enum ImageCodingKey: CodingKey {
        case medium
    }
    
    init(id: Int,
         name: String,
         image: URL?,
         castShows: [Show]?) {
        self.id = id
        self.name = name
        self.image = image
        self.castShows = castShows
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        if let imageInfo = try? container.nestedContainer(keyedBy: ImageCodingKey.self, forKey: .image),
            let imageUrlString = try? imageInfo.decode(String.self, forKey: .medium) {
            image = URL(string: imageUrlString)
        }
    }
    
}

// MARK: - Hashable

extension Person: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: - SimpleDataSourceExposable

extension Person: SimpleDataSourceExposable {
    
    var url: URL? { return image }
    var text: String? { return name }
    
}
