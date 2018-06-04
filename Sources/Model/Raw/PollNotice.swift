//
//  PollNotice.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

public struct PollNotice: Equatable {
    public var id: Poll.ID
    public var token: String
    public var prompt: String
    public var closedAt: Date
    public var options: Set<Option>
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(id: Poll.ID, token: String, prompt: String, closedAt: Date, options: Set<Option>, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.id = id
        self.token = token
        self.prompt = prompt
        self.closedAt = closedAt
        self.options = options
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Raw {
    public static let pollNotice: Identifier = "io.pnut.core.poll-notice"
}


extension PollNotice: RawContentValueType {
    public static let validDecodableKeys: Keys = makeValidDecodableKeys()
}


extension PollNotice: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        id = try container.decode(Poll.ID.self, forKey: .pollID)
        token = try container.decode(String.self, forKey: .pollToken)
        prompt = try container.decode(String.self, forKey: .pollPrompt)
        closedAt = try container.decode(Date.self, forKey: .pollClosedAt)
        options = try container.decode(Set<Option>.self, forKey: .pollOptions)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: PollNotice.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encode(id, forKey: .pollID)
        try container.encode(token, forKey: .pollToken)
        try container.encode(prompt, forKey: .pollPrompt)
        try container.encode(closedAt, forKey: .pollClosedAt)
        try container.encode(options, forKey: .pollOptions)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension Identifier where T == RawContent {
    static let pollID: Identifier = "poll_id"
    static let pollToken: Identifier = "poll_token"
    static let pollPrompt: Identifier = "prompt"
    static let pollClosedAt: Identifier = "closed_at"
    static let pollOptions: Identifier = "options"
}


private extension PollNotice {
    static func makeValidDecodableKeys() -> Keys {
        var result = Keys()
        result.insert(.pollID)
        result.insert(.pollToken)
        result.insert(.pollPrompt)
        result.insert(.pollClosedAt)
        result.insert(.pollOptions)
        
        return result
    }
}
