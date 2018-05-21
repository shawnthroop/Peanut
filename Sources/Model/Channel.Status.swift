//
//  Channel.Status.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension Channel {
    
    public struct Status: Hashable, Codable {
        public var youSubscribed: Bool
        public var youMuted: Bool
        public var hasUnread: Bool
    }
}


private extension Channel.Status {
    enum CodingKeys: String, CodingKey {
        case youSubscribed  = "you_subscribed"
        case youMuted       = "you_muted"
        case hasUnread      = "has_unread"
    }
}
