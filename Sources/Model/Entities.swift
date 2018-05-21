//
//  Entities.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Entities: Hashable, Codable {
    public var mentions: Set<Mention>
    public var links: Set<Link>
    public var hashtags: Set<Hashtag>
    
    public init(mentions: Set<Mention> = [], links: Set<Link> = [], hashtags: Set<Hashtag> = []) {
        self.mentions = mentions
        self.links = links
        self.hashtags = hashtags
    }
}


private extension Entities {
    enum CodingKeys: String, CodingKey {
        case mentions
        case links
        case hashtags   = "tags"
    }
}


extension Entities: SurrogatePairAdjustable {
    public func adjusted(for pairs: Set<String.SurrogatePair>) -> Entities {
        if pairs.isEmpty {
            return self
        }
        
        let adjustedMentions = mentions.adjusted(for: pairs)
        let adjustedLinks = links.adjusted(for: pairs)
        let adjustedHashtags = hashtags.adjusted(for: pairs)
        
        return Entities(mentions: adjustedMentions, links: adjustedLinks, hashtags: adjustedHashtags)
    }
}


extension Set: SurrogatePairAdjustable where Element: SurrogatePairAdjustable {
    public func adjusted(for pairs: Set<String.SurrogatePair>) -> Set<Element> {
        return reduce(into: Set(), { $0.insert($1.adjusted(for: pairs)) })
    }
}
