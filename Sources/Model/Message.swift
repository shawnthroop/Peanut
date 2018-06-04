//
//  Message.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Message: Hashable {
    public var id: Identifier<Message>
    public var replyTo: Identifier<Message>?
    public var thread: Identifier<Message>?
    public var user: User.Value?
    public var isDeleted: Bool
    public var content: Content?
    public var isSticky: Bool
    public var source: Source
    public var createdAt: Date
    
    public init(id: Identifier<Message>, replyTo: Identifier<Message>?, thread: Identifier<Message>?, user: User.Value?, isDeleted: Bool, content: Content?, isSticky: Bool, source: Source, createdAt: Date) {
        self.id = id
        self.replyTo = replyTo
        self.thread = thread
        self.user = user
        self.isDeleted = isDeleted
        self.content = content
        self.isSticky = isSticky
        self.source = source
        self.createdAt = createdAt
    }
}


public extension APIParameterKey {
    public static let includeMessageHTML = APIParameterKey("include_message_html")
    public static let includeMessageRaw = APIParameterKey("include_message_raw")
}


extension Message: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension Message: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = makeDefaultParameters()
}


extension Message: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Identifier<Message>.self, forKey: .id)
        replyTo = try container.decodeIfPresent(Identifier<Message>.self, forKey: .replyTo)
        thread = try container.decodeIfPresent(Identifier<Message>.self, forKey: .thread)
        user = try container.decodeIfPresent(User.Value.self, forKey: .user)
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        content = isDeleted ? nil : try container.decode(Content.self, forKey: .content)
        isSticky = try container.decode(Bool.self, forKey: .isSticky)
        source = try container.decode(Source.self, forKey: .source)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(replyTo, forKey: .replyTo)
        try container.encodeIfPresent(thread, forKey: .thread)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(isDeleted, forKey: .isDeleted, where: { $0 == true })
        try container.encodeIfPresent(content, forKey: .content)
        try container.encode(isSticky, forKey: .isSticky)
        try container.encode(source, forKey: .source)
        try container.encode(createdAt, forKey: .createdAt)
    }
}


private extension Message {
    enum CodingKeys: String, CodingKey {
        case id
        case replyTo    = "reply_to"
        case thread     = "thread_id"
        case user
        case isDeleted  = "is_deleted"
        case content
        case isSticky   = "is_sticky"
        case source
        case createdAt  = "created_at"
    }
    
    static func makeDefaultParameters() -> APIParameters {
        var result = APIParameters()
        result[.includeDeleted] = true
        result[.includeHTML] = true
        result[.includeMessageHTML] = true
        result[.includeRaw] = false
        result[.includeMessageRaw] = false
        result[.includeClient] = true
        
        return result
    }
}
