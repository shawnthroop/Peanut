//
//  Poll.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

public struct Poll: Hashable, Encodable {
    public var id: Identifier<Poll>
    public var type: String
    public var prompt: String
    public var options: Set<Poll.Option>
    public var isPublic: Bool
    public var isAnonymous: Bool
    public var isDeleted: Bool
    public var user: User.Value?
    public var token: String?
    public var source: Source
    public var createdAt: Date
}


extension APIParameterKey {
    public static let includeClosed = APIParameterKey("include_closed")
    public static let pollTypes = APIParameterKey("poll_types")
    public static let excludePollTypes = APIParameterKey("exclude_poll_types")
    public static let includePollRaw = APIParameterKey("include_poll_raw")
}


extension Poll: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension Poll: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = makeDefaultParameters()
}


extension Poll: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Poll.ID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        prompt = try container.decode(String.self, forKey: .prompt)
        options = try container.decode(Set<Poll.Option>.self, forKey: .options)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        isAnonymous = try container.decode(Bool.self, forKey: .isAnonymous)
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        user = try container.decodeIfPresent(User.Value.self, forKey: .user)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        source = try container.decode(Source.self, forKey: .source)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}

private extension Poll {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case prompt
        case options
        case isPublic       = "is_public"
        case isAnonymous    = "is_anonymous"
        case isDeleted      = "is_deleted"
        case user
        case token          = "poll_token"
        case source
        case createdAt      = "created_at"
    }
    
    static func makeDefaultParameters() -> APIParameters {
        var result = APIParameters()
        result[.includeClosed] = true
        result[.includePrivate] = true
        result[.includeRaw] = false
        result[.includePollRaw] = false
        
        return result
    }
}
