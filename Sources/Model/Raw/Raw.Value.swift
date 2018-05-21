//
//  Raw.Value.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Raw {
    
    public enum Value: Equatable {
        //        case channel()
        //        case chatSettings
        case crossPost(CrossPost)
        case language(Language)
        case oembed(Oembed)
        case other
    }
}


extension Raw.Value: Identifiable {
    public typealias IdentifierValue = String
}


public extension Raw.Value {
    public var supportedKeys: Raw.ContainerKeys? {
        switch self {
        case .crossPost:
            return CrossPost.supportedKeys
            
        case .language:
            return Language.supportedKeys
            
        case .oembed(let oembed):
            return oembed.oembedValueType.supportedKeys
            
        case .other:
            return nil
        }
    }
}


private extension Oembed {
    var oembedValueType: OembedValueType.Type {
        switch self {
        case .photo:
            return OembedPhoto.self
        case .rich:
            return OembedRich.self
        }
    }
}
