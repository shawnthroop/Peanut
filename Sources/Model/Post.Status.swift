//
//  Post.Status.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post {
    
    public struct Status: Equatable {
        public var youBookmarked: Bool
        public var youReposted: Bool
        public var bookmarkedBy: [User]?
        public var repostedBy: [User]?
    }
}


extension Post.Status: Hashable {
    public var hashValue: Int {
        var result = youBookmarked.hashValue ^ youReposted.hashValue
        
        for case let users? in [bookmarkedBy, repostedBy] {
            result ^= users.reduce(into: 0, { $0 = $0 ^ $1.id.hashValue })
        }
        
        return result
    }
}


extension Post.Status: Codable {
    private enum CodingKeys: String, CodingKey {
        case youBookmarked  = "you_bookmarked"
        case youReposted    = "you_reposted"
        case bookmarkedBy   = "bookmarked_by"
        case repostedBy     = "reposted_by"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        youBookmarked = try container.decodeIfPresent(Bool.self, forKey: .youBookmarked) ?? false
        youReposted = try container.decodeIfPresent(Bool.self, forKey: .youReposted) ?? false
        bookmarkedBy = try container.decodeIfPresent([User].self, forKey: .bookmarkedBy)
        repostedBy = try container.decodeIfPresent([User].self, forKey: .repostedBy)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if youBookmarked {
            try container.encode(youBookmarked, forKey: .youBookmarked)
        }
        
        if youReposted {
            try container.encode(youReposted, forKey: .youReposted)
        }
        
        try container.encodeIfPresent(bookmarkedBy, forKey: .bookmarkedBy)
        try container.encodeIfPresent(repostedBy, forKey: .repostedBy)
    }
}

