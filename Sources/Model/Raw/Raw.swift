//
//  Raw.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Raw: Equatable {
    public var type: Identifier<Raw>
    public var content: RawContent
    
    public init(type: Identifier<Raw>, content: RawContent) {
        self.type = type
        self.content = content
    }
}


extension Raw: Identifiable {
    public typealias IdentifierValue = String
}


extension Raw: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Identifier<Raw>.self, forKey: .type)
        
        func decodeContent<T: Decodable>(_ type: T.Type) throws -> T {
            return try container.decode(type, forKey: .content)
        }
                
        switch type {
        case .channelInvite:
            content = try .channelInvite(decodeContent(ChannelInvite.self))
            
        case .chatSettings:
            content = try .chatSettings(decodeContent(ChatSettings.self))
            
        case .crossPost:
            content = try .crossPost(decodeContent(CrossPost.self))
            
        case .language:
            content = try .language(decodeContent(Language.self))
            
        case .oembed, .oembedMetadata:
            switch try decodeContent(Oembed.self) {
            case .photo(let v):
                content = .oembedPhoto(v)
            case .rich(let v):
                content = .oembedRich(v)
            case .html5Video(let v):
                content = .oembedHTML5Video(v)
            case .audio(let v):
                content = .oembedAudio(v)
            }
            
        case .pollNotice:
            content = try .pollNotice(decodeContent(PollNotice.self))
            
        default:
            let unvalidatedContent = try container.decode(RawUnvalidatedContent.self, forKey: .content)
            
            if unvalidatedContent.isEmpty {
                content = .none
                
            } else {
                content = .unvalidated(unvalidatedContent)
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
        if content != .none {
            try container.encode(content, forKey: .content)
        }
    }
}


private extension RawContent {
    var validDecodableKeys: Set<Identifier<RawContent>>? {
        return rawContentKeyDecodableType?.validDecodableKeys
    }
    
    private var rawContentKeyDecodableType: RawContentKeyDecodable.Type? {
        switch self {
        case .channelInvite:
            return ChannelInvite.self
        case .chatSettings:
            return ChatSettings.self
        case .crossPost:
            return CrossPost.self
        case .language:
            return Language.self
        case .oembedPhoto:
            return OembedPhoto.self
        case .oembedRich:
            return OembedRich.self
        case .oembedHTML5Video:
            return OembedHTML5Video.self
        case .oembedAudio:
            return OembedAudio.self
        case .pollNotice:
            return PollNotice.self
            
        case .unvalidated, .none:
            return nil
        }
    }
}


extension Collection where Element == Raw {
    public func contains(type identifier: Identifier<Raw>) -> Bool {
        return contains(where: { $0.type == identifier })
    }
}

//extension Array where Element == Raw {
//    public func contains(type identifier: Identifier<Raw>) -> Bool {
//        return contains(where: { $0.type == identifier })
//    }
//
//    public var language: Language? {
//        return first(as: { $0.language })
//    }
//
//    public var crossPost: CrossPost? {
//        return first(as: { $0.crossPost })
//    }
//
//    public var photo: OembedPhoto? {
//        return first(as: { $0.photo })
//    }
//
//    public var rich: OembedRich? {
//        return first(as: { $0.rich })
//    }
//
//    public func first(with identifier: Identifier<Raw>) -> Raw? {
//        return first(where: { $0.type == identifier })
//    }
//
//    public func first<T: RawValueType>(as transformed: (Raw) -> T?) -> T? {
//        for raw in self {
//            if let value = transformed(raw) {
//                return value
//            }
//        }
//
//        return nil
//    }
//}


private extension Raw {
    enum CodingKeys: String, CodingKey {
        case type
        case content            = "value"
        case unvalidatedContent
    }
}


extension KeyedDecodingContainer {
    public func decode(_ type: [Raw].Type, forKey key: K) throws -> [Raw] {
        var container = try nestedUnkeyedContainer(forKey: key)
        var result: [Raw] = []
        
        while container.isAtEnd == false {
            var raw: Raw?
            
            do {
                raw = try container.decode(Raw.self)
                
            } catch let error as DecodingError {
                guard case .keyNotFound = error else {
                    throw error
                }
                
            } catch {
                guard error is RawDecodingError else {
                    throw error
                }
            }
            
            if let raw = raw {
                result.append(raw)
            } else {
                let _  = try container.decode(EmptyDecodableValue.self)
            }
        }
        
        return result
    }
}


/// Workaround described here: https://bugs.swift.org/browse/SR-5953
private struct EmptyDecodableValue: Decodable {}

