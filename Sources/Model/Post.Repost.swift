//
//  Post.Repost.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post {
    
    public struct Repost: Hashable {
        public let id: Post.ID
        public var thread: Post.ID?
        public var replyTo: Post.ID?
        public var user: User
        public var isDeleted: Bool
        public var content: Content?
        public var source: Source
        public var status: Post.Status
        public var counts: Post.Counts?
        public var createdAt: Date
    }
}


extension Post.Repost: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Post.CodingKeys.self)
        id = try container.decode(Post.ID.self, forKey: .id)
        thread = try container.decodeIfPresent(Post.ID.self, forKey: .thread)
        replyTo = try container.decodeIfPresent(Post.ID.self, forKey: .replyTo)
        user = try container.decode(User.self, forKey: .user)
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        content = isDeleted ? nil : try container.decode(Content.self, forKey: .content)
        source = try container.decode(Source.self, forKey: .source)
        status = try Post.Status(from: decoder)
        counts = try container.decodeIfPresent(Post.Counts.self, forKey: .counts)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Post.CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(thread, forKey: .thread)
        try container.encodeIfPresent(replyTo, forKey: .replyTo)
        try container.encode(user, forKey: .user)
        
        if isDeleted {
            try container.encode(isDeleted, forKey: .isDeleted)
        }
        
        try container.encodeIfPresent(content, forKey: .content)
        try container.encode(source, forKey: .source)
        try status.encode(to: encoder)
        try container.encodeIfPresent(counts, forKey: .counts)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
