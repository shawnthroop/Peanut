//
//  File.Derivative.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File {
    
    public struct Derivative: Equatable {
        public var name: String
        public var link: Link
        public var mimeType: MimeType
        public var size: Int
        public var sha256: String
        public var information: ImageInformation?
        
        public init(name: String, link: Link, mimeType: MimeType, size: Int, sha256: String, information: ImageInformation?) {
            self.name = name
            self.link = link
            self.mimeType = mimeType
            self.size = size
            self.sha256 = sha256
            self.information = information
        }
    }
}


extension File.Derivative: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        link = try File.Link(from: decoder)
        mimeType = try container.decode(File.MimeType.self, forKey: .mimeType)
        size = try container.decode(Int.self, forKey: .size)
        sha256 = try container.decode(String.self, forKey: .sha256)
        information = try container.decodeIfPresent(File.ImageInformation.self, forKey: .information)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try link.encode(to: encoder)
        try container.encode(mimeType, forKey: .mimeType)
        try container.encode(size, forKey: .size)
        try container.encode(sha256, forKey: .sha256)
        try container.encodeIfPresent(information, forKey: .information)
    }
}


private extension File.Derivative {
    enum CodingKeys: String, CodingKey {
        case name
        case mimeType       = "mime_type"
        case size
        case sha256
        case information    = "image_info"
    }
}
