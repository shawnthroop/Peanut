//
//  Raw.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Raw: Equatable {
    public var type: Identifier<Raw>
    public var value: Value
    
    private let additional: Container
    
    public init(unvalidatedType type: Identifier<Raw>, rawValue: [String: Any]) {
        self.type = type
        self.value = .other
        self.additional = Raw.Container(rawValue: rawValue)
    }
}


extension Raw: Identifiable {
    public typealias IdentifierValue = String
}


extension Raw: RawContainerType {
    public func decode(_ type: Bool.Type, forKey key: Raw.ContainerKey) -> Bool? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: Int.Type, forKey key: Raw.ContainerKey) -> Int? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: Double.Type, forKey key: Raw.ContainerKey) -> Double? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: String.Type, forKey key: Raw.ContainerKey) -> String? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: [Bool].Type, forKey key: Raw.ContainerKey) -> [Bool]? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: [Int].Type, forKey key: Raw.ContainerKey) -> [Int]? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: [Double].Type, forKey key: Raw.ContainerKey) -> [Double]? {
        return additional.decode(type, forKey: key)
    }
    
    public func decode(_ type: [String].Type, forKey key: Raw.ContainerKey) -> [String]? {
        return additional.decode(type, forKey: key)
    }
    
    public func nestedContainer(forKey key: Raw.ContainerKey) -> RawContainerType? {
        return additional.nestedContainer(forKey: key)
    }
    
    public func nestedContainers(forKey key: Raw.ContainerKey) -> [RawContainerType]? {
        return additional.nestedContainers(forKey: key)
    }
}


extension Raw: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.nestedContainer(keyedBy: ContainerKey.self, forKey: .value)
        
        let decodedType = try container.decode(Identifier<Raw>.self, forKey: .type)
        let decodedValue: Value?
        
        func decodeValue<T: RawCodable>(_ type: T.Type) throws -> T? {
            do {
                return try T(from: values)
                
            } catch let error as DecodingError {
                guard case .keyNotFound = error else {
                    throw error
                }
                
            } catch {
                throw error
            }
            
            return nil
        }
        
        switch decodedType {
        case .language:
            decodedValue = try decodeValue(Language.self).map { .language($0) }
            
        case .oembed, .oembedMetadata:
            decodedValue = try decodeValue(Oembed.self).map { .oembed($0) }
            
        case .crossPost:
            decodedValue = try decodeValue(CrossPost.self).map { .crossPost($0) }
            
        default:
            decodedValue = nil
        }
        
        type = decodedType
        value = decodedValue ?? .other
        
        let supportedKeys = value.supportedKeys ?? []
        additional = try Container(from: values, filter: { !supportedKeys.contains($0) })
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Raw.CodingKeys.self)
        var values = container.nestedContainer(keyedBy: Raw.ContainerKey.self, forKey: .value)
        
        try container.encode(type, forKey: .type)
        
        if let value = encodableValue {
            try value.encode(to: &values)
        }
        
        try additional.encode(to: &values)
    }
}


extension Array where Element == Raw {
    public func contains(type identifier: Identifier<Raw>) -> Bool {
        return contains(where: { $0.type == identifier })
    }
    
    public var language: Language? {
        return first(as: { $0.language })
    }
    
    public var crossPost: CrossPost? {
        return first(as: { $0.crossPost })
    }
    
    public var photo: OembedPhoto? {
        return first(as: { $0.photo })
    }
    
    public var rich: OembedRich? {
        return first(as: { $0.rich })
    }
    
    public func first(with identifier: Identifier<Raw>) -> Raw? {
        return first(where: { $0.type == identifier })
    }
    
    public func first<T: RawValueType>(as transformed: (Raw) -> T?) -> T? {
        for raw in self {
            if let value = transformed(raw) {
                return value
            }
        }
        
        return nil
    }
}


private extension Raw {
    enum CodingKeys: CodingKey {
        case type
        case value
    }
    
    var encodableValue: RawEncodable? {
        switch value {
        case .crossPost(let value):
            return value
        case .language(let value):
            return value
        case .oembed(let value):
            return value
        case .other:
            return nil
        }
    }
}
