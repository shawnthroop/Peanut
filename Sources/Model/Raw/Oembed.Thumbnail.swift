//
//  Oembed.Thumbnail.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Oembed {
    
    public struct Thumbnail: Hashable {
        public var url: URL
        public var width: Int
        public var height: Int
        
        public init(url: URL, width: Int, height: Int) {
            self.url = url
            self.width = width
            self.height = height
        }
    }
}


extension Identifier where T == RawContent {
    public static let thumbnailURL = Identifier(value: "thumbnail_url")
    public static let thumbnailWidth = Identifier(value: "thumbnail_width")
    public static let thumbnailHeight = Identifier(value: "thumbnail_height")
}


extension Oembed.Thumbnail: RawContentKeyDecodable {
    public static let validDecodableKeys: RawContentKeyDecodable.Keys = [.thumbnailURL, .thumbnailWidth, .thumbnailHeight]
}


extension Oembed.Thumbnail: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        
        guard container.contains(.thumbnailURL) else {
            throw RawDecodingError.keyNotFound(.thumbnailURL, codingPath: decoder.codingPath)
        }
        
        url = try container.decode(URL.self, forKey: .thumbnailURL)
        width = try container.decode(Int.self, forKey: .thumbnailWidth)
        height = try container.decode(Int.self, forKey: .thumbnailHeight)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encode(url, forKey: .thumbnailURL)
        try container.encode(width, forKey: .thumbnailWidth)
        try container.encode(height, forKey: .thumbnailHeight)
    }
}


//extension Raw {
//    var thumbnail: Oembed.Thumbnail? {
//        return Oembed.Thumbnail(from: self)
//    }
//}
//
//
//extension Oembed.Thumbnail: RawValueType {
//    public static let supportedKeys: Raw.ContainerKeys = [.thumbnailURL, .thumbnailWidth, .thumbnailHeight]
//}
//
//
//extension Oembed.Thumbnail: RawCodable, Codable {
//    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
//        guard container.contains(.thumbnailURL) else {
//            return nil
//        }
//        
//        url = try container.decode(URL.self, forKey: .thumbnailURL)
//        width = try container.decode(Int.self, forKey: .thumbnailWidth)
//        height = try container.decode(Int.self, forKey: .thumbnailHeight)
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Raw.ContainerKey.self)
//
//        guard container.contains(.thumbnailURL) else {
//            throw Raw.DecodingError.keyNotFound(.thumbnailURL)
//        }
//
//        url = try container.decode(URL.self, forKey: .thumbnailURL)
//        width = try container.decode(Int.self, forKey: .thumbnailWidth)
//        height = try container.decode(Int.self, forKey: .thumbnailHeight)
//    }
//    
//    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
//        try container.encode(url, forKey: .url)
//        try container.encode(width, forKey: .width)
//        try container.encode(height, forKey: .height)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Raw.ContainerKey.self)
//        try container.encode(url, forKey: .url)
//        try container.encode(width, forKey: .width)
//        try container.encode(height, forKey: .height)
//    }
//}
//
//
//extension Oembed.Thumbnail: RawContainerDecodable {
//    public init?(from container: RawContainerType) {
//        guard
//            let url = container.decode(URL.self, forKey: .thumbnailURL),
//            let width = container.decode(Int.self, forKey: .thumbnailWidth),
//            let height = container.decode(Int.self, forKey: .thumbnailHeight) else {
//                return nil
//        }
//        
//        self.init(url: url, width: width, height: height)
//    }
//}
