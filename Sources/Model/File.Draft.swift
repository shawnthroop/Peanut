//
//  File.Draft.swift
//  Peanut
//
//  Created by Shawn Throop on 23.05.18.
//

extension File {
    
    public struct Draft: Equatable {
        public var type: String
        public var kind: Kind
        public var name: String
        public var isPublic: Bool
        public var mimeType: MimeType?
        public var content: Data?
        public var sha256: String?
        
        public init(type: String, kind: Kind, name: String, isPublic: Bool, mimeType: MimeType?, content: Data?, sha256: String?) {
            self.type = type
            self.kind = kind
            self.name = name
            self.isPublic = isPublic
            self.mimeType = mimeType
            self.content = content
            self.sha256 = sha256
        }
    }
}


extension File.Draft {
    static func jpg(_ data: Data, type: String, name: String, isPublic: Bool, sha256: String? = nil) -> File.Draft {
        return File.Draft(type: type, kind: .image, name: name, isPublic: isPublic, mimeType: .jpg, content: data, sha256: sha256)
    }
    
    static func png(_ data: Data, type: String, name: String, isPublic: Bool, sha256: String? = nil) -> File.Draft {
        return File.Draft(type: type, kind: .image, name: name, isPublic: isPublic, mimeType: .png, content: data, sha256: sha256)
    }
}
