//
//  Channel.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Channel: Hashable {
    public var id: Identifier<Channel>
    public var type: String
    public var owner: User.Value?
    public var recentMessageID: Message.ID?
    public var recentMessage: Message?
    public var isActive: Bool
    public var permissions: Permissions
    public var counts: Counts
    public var status: Status
}


public extension APIParameterKey {
    public static let includeRead = APIParameterKey("include_read")
    public static let channelTypes = APIParameterKey("channel_types")
    public static let excludeChannelTypes = APIParameterKey("exclude_channel_types")
    public static let includeMarker = APIParameterKey("include_marker")
    public static let includeInactive = APIParameterKey("include_inactive")
    public static let includeChannelRaw = APIParameterKey("include_channel_raw")
    public static let includeRecentMessage = APIParameterKey("include_recent_message")
    public static let includeLimitedUsers = APIParameterKey("include_limited_users")
}


extension Channel: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension Channel: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = makeDefaultParameters()
}


private extension Channel {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case owner
        case recentMessageID    = "recent_message_id"
        case recentMessage      = "recent_message"
        case isActive           = "is_active"
        case permissions        = "acl"
        case counts
    }
    
    static func makeDefaultParameters() -> APIParameters {
        var result = APIParameters()
        result[.includeRead] = true
        result[.includeMarker] = true
        result[.includeInactive] = false
        result[.includeRaw] = false
        result[.includeChannelRaw] = false
        result[.includeRecentMessage] = false
        result[.includeLimitedUsers] = false
        
        return result
    }
}
