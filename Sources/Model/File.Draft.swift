//
//  File.Draft.swift
//  Peanut
//
//  Created by Shawn Throop on 23.05.18.
//

extension File {
    
    public struct Draft: Equatable, Codable {
        public var type: String
        public var kind: Kind
        public var name: String
        public var isPublic: Bool
        public var mimeType: MimeType?
        public var raw: [Raw]
        
        public init(type: String, kind: Kind, name: String, isPublic: Bool, mimeType: MimeType?, raw: [Raw]) {
            self.type = type
            self.kind = kind
            self.name = name
            self.isPublic = isPublic
            self.mimeType = mimeType
            self.raw = raw
        }
        
        public init(type: String, mimeType: MimeType, name: String, isPublic: Bool = false, raw: [Raw] = []) {
            self.init(type: type, kind: mimeType.kind, name: name, isPublic: isPublic, mimeType: mimeType, raw: raw)
        }
    }
}


private extension File.Draft {
    enum CodingKeys: String, CodingKey {
        case type
        case kind
        case name
        case isPublic = "is_public"
        case mimeType = "mime_type"
        case raw
    }
}
