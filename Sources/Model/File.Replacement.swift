//
//  File.Replacement.swift
//  Peanut
//
//  Created by Shawn Throop on 28.05.18.
//

extension File {
    
    public struct Replacement: Hashable, Codable {
        public var format: ReplacementFormat
        public var id: File.ID
        public var token: String
        
        public init(format: ReplacementFormat, id: File.ID, token: String) {
            self.format = format
            self.id = id
            self.token = token
        }
    }
}


extension Identifier where T == RawContent {
    public static let fileReplacement: Identifier = "+io.pnut.core.file"
}


extension Raw {
    public static func fileReplacement(_ value: File.Replacement, type: Identifier<Raw>, content: RawUnvalidatedContent = .empty) -> Raw {
        return Raw(type: type, content: .unvalidated(content.with({ $0[.fileReplacement] = value })))
    }
    
    public static func oembedReplacement(id: File.ID, token: String, content: RawUnvalidatedContent = .empty) -> Raw {
        return fileReplacement(File.Replacement(format: .oembed, id: id, token: token), type: .oembed, content: content)
    }
}


private extension File.Replacement {
    enum CodingKeys: String, CodingKey {
        case format
        case id     = "file_id"
        case token  = "file_token"
    }
}
