//
//  RawDecodingError.swift
//  Peanut
//
//  Created by Shawn Throop on 27.05.18.
//

enum RawDecodingError: Error {
    case oembedTypeMismatch(OembedValueType.Type, type: Identifier<Oembed>, codingPath: [CodingKey])
    case oembedTypeNotSupported(type: Identifier<Oembed>, codingPath: [CodingKey])
    case keyNotFound(Identifier<RawContent>, codingPath: [CodingKey])
}


//extension UnkeyedDecodingContainer {
//    mutating func decode<T: Decodable>(unvalidated type: [T].Type) throws -> [T] {
//        var result: [T] = []
//        
//        while isAtEnd == false {
//            do {
//                try result.append(decode(T.self))
//                
//            } catch {
//                guard error.isKeyNotFound else {
//                    throw error
//                }
//            }
//        }
//        
//        return result
//    }
//}


internal extension Decodable {
    
    /// Attempts to decode a value from the decoder but if keys are missing, nil is returned.
    /// Errors and other DecodingErrors (typeMismatch, valueNotFound, etc...) are handled normally.
    init?(fromUnvalidated decoder: Decoder) throws {
        var result: Self?
        
        do {
            result = try Self(from: decoder)
            
        } catch {
            guard error.isKeyNotFound else {
                throw error
            }
        }
        
        guard let this = result else {
            return nil
        }
        
        self = this
    }
}


private extension Error {
    var isKeyNotFound: Bool {
        switch self {
        case let error as RawDecodingError:
            if case .keyNotFound = error {
                return true
            }
            
        case let error as DecodingError:
            if case .keyNotFound = error {
                return true
            }
            
        default:
            break
        }
        
        return false
    }
}
