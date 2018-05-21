//
//  User.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct User: Hashable {
    public var id: Identifier<User>
    public var username: String
    public var name: String?
    public var cover: Image
    public var avatar: Image
    public var content: Content?
    public var kind: User.Kind
    public var counts: User.Counts?
    public var createdAt: Date
    public let badge: User.Badge?
    public let verification: User.Verification?
    
    init(id: Identifier<User>, username: String, name: String?, cover: Image, avatar: Image, content: Content?, kind: Kind, counts: User.Counts?, createdAt: Date, badge: User.Badge? = nil, verification: User.Verification? = nil) {
        self.id = id
        self.username = username
        self.name = name
        self.cover = cover
        self.avatar = avatar
        self.content = content
        self.kind = kind
        self.counts = counts
        self.createdAt = createdAt
        self.badge = badge
        self.verification = verification
    }
}


extension APIParameterKey {
    public static let includeUserHTML = APIParameterKey("include_user_html")
    public static let includeUser = APIParameterKey("include_user")
    public static let includePresence = APIParameterKey("include_presence")
    public static let includeUserRaw = APIParameterKey("include_user_raw")
}


extension User: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension User: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = makeDefaultParameters()
}


extension User: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Identifier<User>.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        
        if decoder.context?.source == .remote {
            name = try container.decodeIfPresent(String.self, forKey: .name).flatMap { rawName in
                let trimmedName = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmedName.isEmpty ? nil : rawName
            }
            
        } else {
            name = try container.decodeIfPresent(String.self, forKey: .name)
        }
        
        let contentContainer = try container.nestedContainer(keyedBy: ContentCodingKeys.self, forKey: .content)
        cover = try contentContainer.decode(Image.self, forKey: .cover)
        avatar = try contentContainer.decode(Image.self, forKey: .avatar)
        content = contentContainer.contains(.text) ? try container.decode(Content.self, forKey: .content) : nil
        
        kind = try container.decode(Kind.self, forKey: .kind)
        counts = try container.decodeIfPresent(Counts.self, forKey: .counts)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        badge = try container.decodeIfPresent(Badge.self, forKey: .badge)
        verification = try container.decodeIfPresent(Verification.self, forKey: .verification)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encodeIfPresent(name, forKey: .name)
        
        var contentContainer = container.nestedContainer(keyedBy: ContentCodingKeys.self, forKey: .content)
        try contentContainer.encode(cover, forKey: .cover)
        try contentContainer.encode(avatar, forKey: .avatar)
        try container.encodeIfPresent(content, forKey: .content)
        
        try container.encode(kind, forKey: .kind)
        try container.encodeIfPresent(counts, forKey: .counts)
        try container.encode(createdAt, forKey: .createdAt)
        
        try container.encodeIfPresent(badge, forKey: .badge)
        try container.encodeIfPresent(verification, forKey: .verification)
    }
}


private extension User {
    static func makeDefaultParameters() -> APIParameters {
        var result = APIParameters()
        result[.includeHTML] = true
        result[.includeUserHTML] = true
        result[.includeCounts] = true
        result[.includeUser] = true
        result[.includePresence] = false
        result[.includeRaw] = false
        result[.includeUserRaw] = false
        
        return result
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case content
        case kind           = "type"
        case counts
        case createdAt      = "created_at"
        case badge
        case verification   = "verified"
    }
    
    enum ContentCodingKeys: String, CodingKey {
        case avatar = "avatar_image"
        case cover = "cover_image"
        case text
    }
}
