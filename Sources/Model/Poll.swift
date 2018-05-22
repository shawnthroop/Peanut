//
//  Poll.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

public struct Poll: Hashable, Codable {
    public var id: Identifier<Poll>
    public var type: String
    public var prompt: String
    public var options: Set<Poll.Option>
    public var isPublic: Bool
    public var isAnonymous: Bool
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


private extension Poll {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case prompt
        case options
        case isPublic       = "is_public"
        case isAnonymous    = "is_anonymous"
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
