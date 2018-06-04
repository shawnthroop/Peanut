//
//  ChannelInvite.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

public struct ChannelInvite: Equatable {
    public var id: Channel.ID
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(id: Channel.ID, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.id = id
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Raw {
    public static let channelInvite: Identifier = "io.pnut.core.channel.invite"
}


extension ChannelInvite: RawContentValueType {
    public static let validDecodableKeys: Keys = [.channelID]
}


extension ChannelInvite: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        id = try container.decode(Channel.ID.self, forKey: .channelID)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: ChannelInvite.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encode(id, forKey: .channelID)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension Identifier where T == RawContent {
    static let channelID: Identifier = "channel_id"
}
