//
//  Poll.Replacement.swift
//  Peanut
//
//  Created by Shawn Throop on 28.05.18.
//

extension Poll {
    
    public struct Replacement: Hashable, Codable {
        public var id: Poll.ID
        public var token: String
        
        public init(id: Poll.ID, token: String) {
            self.id = id
            self.token = token
        }
    }
}


extension Identifier where T == RawContent {
    public static let pollReplacement: Identifier = "+io.pnut.core.poll"
}


extension Raw {
    public static func pollReplacement(_ value: Poll.Replacement, type: Identifier<Raw> = .pollNotice, content: RawUnvalidatedContent = .empty) -> Raw {
        return Raw(type: type, content: .unvalidated(content.with({ $0[.pollReplacement] = value })))
    }
}


private extension Poll.Replacement {
    enum CodingKeys: String, CodingKey {
        case id     = "poll_id"
        case token  = "poll_token"
    }
}
