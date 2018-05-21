//
//  User.Status.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User {
    
    public struct Status: Hashable {
        public var followsYou: Bool
        public var youFollow: Bool
        public var youCanFollow: Bool
        public var youMuted: Bool
        public var youBlocked: Bool
        
        public init(followsYou: Bool, youFollow: Bool, youCanFollow: Bool, youMuted: Bool, youBlocked: Bool) {
            self.followsYou = followsYou
            self.youFollow = youFollow
            self.youCanFollow = youCanFollow
            self.youMuted = youMuted
            self.youBlocked = youBlocked
        }
    }
}


extension User.Status: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if decoder.context?.source == .remote {
            // When accessing an unauthenticated stream (e.g. global) these keys are ommited.
            followsYou = try container.decodeIfPresent(Bool.self, forKey: .followsYou) ?? false
            youFollow = try container.decodeIfPresent(Bool.self, forKey: .youFollow) ?? false
            youCanFollow = try container.decodeIfPresent(Bool.self, forKey: .youCanFollow) ?? false
            youMuted = try container.decodeIfPresent(Bool.self, forKey: .youMuted) ?? false
            youBlocked = try container.decodeIfPresent(Bool.self, forKey: .youBlocked) ?? false
            
        } else {
            followsYou = try container.decode(Bool.self, forKey: .followsYou)
            youFollow = try container.decode(Bool.self, forKey: .youFollow)
            youCanFollow = try container.decode(Bool.self, forKey: .youCanFollow)
            youMuted = try container.decode(Bool.self, forKey: .youMuted)
            youBlocked = try container.decode(Bool.self, forKey: .youBlocked)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(followsYou, forKey: .followsYou)
        try container.encode(youFollow, forKey: .youFollow)
        try container.encode(youCanFollow, forKey: .youCanFollow)
        try container.encode(youMuted, forKey: .youMuted)
        try container.encode(youBlocked, forKey: .youBlocked)
    }
}


private extension User.Status {
    enum CodingKeys: String, CodingKey {
        case followsYou     = "follows_you"
        case youFollow      = "you_follow"
        case youCanFollow   = "you_can_follow"
        case youMuted       = "you_muted"
        case youBlocked     = "you_blocked"
    }
}
