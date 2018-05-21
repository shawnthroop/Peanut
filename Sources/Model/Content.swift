//
//  Content.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Content: Hashable {
    public var content: String
    public var html: String?
    public var entities: Entities
    
    public init(content: String, html: String? = nil, entities: Entities) {
        self.content = content
        self.html = html
        self.entities = entities
    }
}


extension Content: Codable {
    private enum CodingKeys: String, CodingKey {
        case content    = "text"
        case html
        case entities
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        html = try container.decodeIfPresent(String.self, forKey: .html)
        entities = try container.decode(Entities.self, forKey: .entities)
        
        if decoder.context?.source == .remote {
            entities.adjust(for: content.surrogatePairs)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encodeIfPresent(html, forKey: .html)
        
        var adjustedEntities = entities
        if encoder.context?.destination == .remote {
            adjustedEntities.adjust(for: content.invertedSurrogatePairs)
        }
        
        try container.encode(adjustedEntities, forKey: .entities)
    }
}

