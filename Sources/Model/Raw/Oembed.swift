//
//  Oembed.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public enum Oembed: Equatable {
    case photo(OembedPhoto)
    case rich(OembedRich)
    case html5Video(OembedHTML5Video)
    case audio(OembedAudio)
}


public extension Identifier where T == Raw {
    public static let oembed: Identifier = "io.pnut.core.oembed"
    public static let oembedMetadata: Identifier = "io.pnut.core.oembed.metadata"
}


public extension Identifier where T == RawContent {
    public static let type: Identifier = "type"
    public static let version: Identifier = "version"
    public static let width: Identifier = "width"
    public static let height: Identifier = "height"
    public static let url: Identifier = "url"
    public static let html: Identifier = "html"
    public static let embeddableURL: Identifier = "embeddable_url"
    public static let title: Identifier = "title"
    public static let description: Identifier = "description"
    public static let authorName: Identifier = "author_name"
    public static let authorURL: Identifier = "author_url"
    public static let providerName: Identifier = "provider_name"
    public static let providerURL: Identifier = "provider_url"
    public static let cacheAge: Identifier = "cache_age"
    public static let posterURL: Identifier = "poster_url"
}


extension Oembed {
    public var photo: OembedPhoto? {
        guard case let .photo(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var rich: OembedRich? {
        guard case let .rich(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var html5Video: OembedHTML5Video? {
        guard case let .html5Video(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var audio: OembedAudio? {
        guard case let .audio(value) = self else {
            return nil
        }
        
        return value
    }
}


extension Oembed: Identifiable {
    public typealias IdentifierValue = String
}


extension Oembed: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        let type = try container.decode(Identifier<Oembed>.self, forKey: .type)
        
        switch type {
        case .photo:
            self = try .photo(OembedPhoto(from: decoder))

        case .rich:
            self = try .rich(OembedRich(from: decoder))

        case .html5Video:
            self = try .html5Video(OembedHTML5Video(from: decoder))
            
        case .audio:
            self = try .audio(OembedAudio(from: decoder))
            
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Oembed type \(type) not supported"))
        }
//        var result: Oembed?
//
//        if let type = try container.decodeIfPresent(Identifier<Oembed>.self, forKey: .type) {
//            print("type:", type)
//
//            switch type {
//            case .photo:
////                result = try OembedPhoto(fromUnvalidated: decoder).map({ .photo($0) })
//                result = try .photo(OembedPhoto(from: decoder))
//
//            case .rich:
//                result = try .rich(OembedRich(from: decoder))
////                result = try OembedRich(fromUnvalidated: decoder).map({ .rich($0) })
//
//            case .html5Video:
//                result = try .html5Video(OembedHTML5Video(from: decoder))
////                result = try OembedHTML5Video(fromUnvalidated: decoder).map({ .html5Video($0) })
//
//            default:
//                break
//            }
//
////        } else {
////            if let id = try container.decodeIfPresent(Poll.ID.self, forKey: .pollID) {
////
////            } else if let id = try container.decodeIfPresent(File.ID.self, forKey: .fileID) {
////
////            }
//        }
//
//        guard let this = result else {
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode Oembed from provided data"))
//        }
//
//        self = this
    }
}


private extension Identifier where T == RawContent {
    static let pollID: Identifier = "poll_id"
    static let fileID: Identifier = "file_id"
}


//extension Raw {
//    public var oembed: Oembed? {
//        if case let .oembed(v) = value {
//            return v
//        }
//        
//        return nil
//    }
//    
//    public var photo: OembedPhoto? {
//        if case let .photo(v)? = oembed {
//            return v
//        }
//        
//        return nil
//    }
//    
//    public var rich: OembedRich? {
//        if case let .rich(v)? = oembed {
//            return v
//        }
//        
//        return nil
//    }
//}
//
//
//internal extension Oembed {
//    static let requiredKeys: Raw.ContainerKeys = [.type, .version]
//}
//
//
//extension Oembed: RawCodable {
////    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
////        var result: Oembed?
////
////        switch try container.decode(String.self, forKey: .type) {
////        case OembedPhoto.oembedType:
////            result = try OembedPhoto(from: container).map { .photo($0) }
////
////        case OembedRich.oembedType:
////            result = try OembedRich(from: container).map { .rich($0) }
////
////        default:
////            break
////        }
////
////        guard let this = result else {
////            return nil
////        }
////
////        self = this
////    }
////
////    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
////        try oembedValue.encode(to: &container)
////    }
//}
//
//
//extension Oembed: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Raw.ContainerKey.self)
//        let result: Oembed?
//        
//        if let type = try container.decodeIfPresent(String.self, forKey: .type) {
//            switch type {
//            case OembedPhoto.oembedType:
//                result = try OembedPhoto(optionalFrom: decoder).map { .photo($0) }
//                
//            case OembedRich.oembedType:
//                result = try OembedRich(optionalFrom: decoder).map { .rich($0) }
//                
//            default:
//                result = nil
//            }
//            
//        } else {
//            result = nil
////            if let value = try File(optionalFrom: decoder) {
////                self = .file(value)
////            } else if let value = try Poll(optionalFrom: decoder) {
////                self = .poll(value)
////            }
//        }
//        
//        
//        
//        if let this = result {
//            self = this
//            
//        } else {
//            throw DecodingError.oembedNotSupported(codingPath: decoder.codingPath)
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        try rawEncodableValue.encode(to: encoder)
//    }
//}
//
//
//private extension DecodingError {
//    static func oembedNotSupported(codingPath path: [CodingKey]) -> DecodingError {
//        return .dataCorrupted(Context(codingPath: path, debugDescription: "Unable to serialize Oembed"))
//    }
//}
//
//
//private extension Oembed {
//    var rawEncodableValue: RawEncodable {
//        switch self {
//        case .photo(let value):
//            return value
//        case .rich(let value):
//            return value
//        }
//    }
//}
