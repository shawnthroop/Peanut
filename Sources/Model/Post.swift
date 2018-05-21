//
//  Post.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Post: Equatable {
    public var id: Identifier<Post>
    public var pagination: Identifier<Post>?
    public var thread: Identifier<Post>?
    public var replyTo: Identifier<Post>?
    public var user: User
    public var isDeleted: Bool
    public var content: Content?
    public var repostOf: Repost?
    public var raw: [Raw]
    public var source: Source
    public var status: Post.Status
    public var counts: Post.Counts?
    public var createdAt: Date
    
    init(id: Identifier<Post>, pagination: Identifier<Post>?, thread: Identifier<Post>?, replyTo: Identifier<Post>?, user: User, isDeleted: Bool, content: Content?, repostOf: Repost, raw: [Raw], source: Source, status: Post.Status, counts: Post.Counts?, createdAt: Date) {
        self.id = id
        self.pagination = pagination
        self.thread = thread
        self.replyTo = replyTo
        self.user = user
        self.isDeleted = isDeleted
        self.content = content
        self.repostOf = repostOf
        self.raw = raw
        self.source = source
        self.status = status
        self.counts = counts
        self.createdAt = createdAt
    }
}


extension APIParameterKey {
    public static let includePostHTML = APIParameterKey("include_post_html")
    public static let includeBookmarkedBy = APIParameterKey("include_bookmarked_by")
    public static let includeRepostedBy = APIParameterKey("include_reposted_by")
    public static let includeDirectedPosts = APIParameterKey("include_directed_posts")
    public static let includeCopyMentions = APIParameterKey("include_copy_mentions")
    public static let includeMuted = APIParameterKey("include_muted")
    public static let includePostRaw = APIParameterKey("include_post_raw")
}


extension Post: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension Post: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = makeDefaultParameters()
}


extension Post: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Identifier<Post>.self, forKey: .id)
        pagination = try container.decodeIfPresent(Identifier<Post>.self, forKey: .pagination)
        thread = try container.decodeIfPresent(Identifier<Post>.self, forKey: .thread)
        replyTo = try container.decodeIfPresent(Identifier<Post>.self, forKey: .replyTo)
        user = try container.decode(User.self, forKey: .user)
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        content = isDeleted ? nil : try container.decode(Content.self, forKey: .content)
        repostOf = try container.decodeIfPresent(Post.Repost.self, forKey: .repostOf)
        raw = try container.decodeIfPresent([Raw].self, forKey: .raw) ?? []
        source = try container.decode(Source.self, forKey: .source)
        status = try Status(from: decoder)
        counts = try container.decodeIfPresent(Counts.self, forKey: .counts)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(pagination, forKey: .pagination)
        try container.encodeIfPresent(thread, forKey: .thread)
        try container.encodeIfPresent(replyTo, forKey: .replyTo)
        try container.encode(user, forKey: .user)
        
        if isDeleted {
            try container.encode(isDeleted, forKey: .isDeleted)
        }
        
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(repostOf, forKey: .repostOf)
        
        if !raw.isEmpty {
            try container.encode(raw, forKey: .raw)
        }
        
        try status.encode(to: encoder)
        try container.encodeIfPresent(counts, forKey: .counts)
        try container.encode(createdAt, forKey: .createdAt)
    }
}


internal extension Post {
    enum CodingKeys: String, CodingKey {
        case id
        case pagination = "pagination_id"
        case thread     = "thread_id"
        case replyTo    = "reply_to"
        case user
        case isDeleted  = "is_deleted"
        case content
        case repostOf   = "repost_of"
        case raw
        case source
        case status
        case counts
        case createdAt  = "created_at"
    }
    
    private static func makeDefaultParameters() -> APIParameters {
        var result = APIParameters()
        result[.includeDeleted] = true
        result[.includeClient] = true
        result[.includeCounts] = true
        result[.includeHTML] = true
        result[.includePostHTML] = true
        result[.includeBookmarkedBy] = false
        result[.includeRepostedBy] = false
        result[.includeDirectedPosts] = true
        result[.includeCopyMentions] = true
        result[.includeMuted] = false
        result[.includeRaw] = false
        result[.includePostRaw] = false
        
        return result
    }
}

