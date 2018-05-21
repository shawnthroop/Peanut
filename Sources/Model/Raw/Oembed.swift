//
//  Oembed.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public enum Oembed: Equatable {
    case photo(OembedPhoto)
    case rich(OembedRich)
}


public extension Identifier where T == Raw {
    public static let oembed: Identifier = "io.pnut.core.oembed"
    public static let oembedMetadata: Identifier = "io.pnut.core.oembed.metadata"
}


public extension Identifier where T == Raw.Value {
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


extension Raw {
    public var oembed: Oembed? {
        if case let .oembed(v) = value {
            return v
        }
        
        return nil
    }
    
    public var photo: OembedPhoto? {
        if case let .photo(v)? = oembed {
            return v
        }
        
        return nil
    }
    
    public var rich: OembedRich? {
        if case let .rich(v)? = oembed {
            return v
        }
        
        return nil
    }
}

internal extension Oembed {
    static let requiredKeys: Raw.ContainerKeys = [.type, .version]
}


extension Oembed: RawCodable {
    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
        var result: Oembed?
        
        switch try container.decode(String.self, forKey: .type) {
        case OembedPhoto.oembedType:
            result = try OembedPhoto(from: container).map { .photo($0) }
            
        case OembedRich.oembedType:
            result = try OembedRich(from: container).map { .rich($0) }
            
        default:
            break
        }
        
        guard let this = result else {
            return nil
        }
        
        self = this
    }
    
    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
        try oembedValue.encode(to: &container)
    }
}


private extension Oembed {
    var oembedValue: OembedValueType {
        switch self {
        case .photo(let value):
            return value
        case .rich(let value):
            return value
        }
    }
}
