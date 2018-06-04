//
//  RawContent.swift
//  Peanut
//
//  Created by Shawn Throop on 28.05.18.
//

public enum RawContent: Equatable {
    case channelInvite(ChannelInvite)
    case chatSettings(ChatSettings)
    case crossPost(CrossPost)
    case language(Language)
    case oembedPhoto(OembedPhoto)
    case oembedRich(OembedRich)
    case oembedHTML5Video(OembedHTML5Video)
    case oembedAudio(OembedAudio)
    case pollNotice(PollNotice)
    case unvalidated(RawUnvalidatedContent)
    case none
}


extension RawContent: Identifiable {
    public typealias IdentifierValue = String
}


extension RawContent {
    public var channelInvite: ChannelInvite? {
        guard case let .channelInvite(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var chatSettings: ChatSettings? {
        guard case let .chatSettings(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var crossPost: CrossPost? {
        guard case let .crossPost(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var language: Language? {
        guard case let .language(value) = self else {
            return nil
        }
        
        return value
    }
    
    public var oembed: Oembed? {
        switch self {
        case .oembedPhoto(let value):
            return .photo(value)
        case .oembedRich(let value):
            return .rich(value)
        case .oembedHTML5Video(let value):
            return .html5Video(value)
        case .oembedAudio(let value):
            return .audio(value)
        default:
            return nil
        }
    }
    
    public var photo: OembedPhoto? {
        return oembed?.photo
    }
    
    public var rich: OembedRich? {
        return oembed?.rich
    }
    
    public var html5Video: OembedHTML5Video? {
        return oembed?.html5Video
    }
    
    public var audio: OembedAudio? {
        return oembed?.audio
    }
    
    public var pollNotice: PollNotice? {
        guard case let .pollNotice(value) = self else {
            return nil
        }
        
        return value
    }
}


extension RawContent: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .channelInvite(let value):
            try container.encode(value)
        case .chatSettings(let value):
            try container.encode(value)
        case .crossPost(let value):
            try container.encode(value)
        case .language(let value):
            try container.encode(value)
        case .oembedPhoto(let value):
            try container.encode(value)
        case .oembedRich(let value):
            try container.encode(value)
        case .oembedHTML5Video(let value):
            try container.encode(value)
        case .oembedAudio(let value):
            try container.encode(value)
        case .pollNotice(let value):
            try container.encode(value)
        case .unvalidated(let value):
            try container.encode(value)
            
        case .none:
            break
        }
    }
}
