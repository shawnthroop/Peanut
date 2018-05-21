//
//  APIAuthorizationResponse.Storage.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension APIAuthorizationResponse {
    
    public struct Storage: Hashable {
        public var available: Int
        public var total: Int
    }
}


extension APIAuthorizationResponse.Storage: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        available = try container.decode(UniqueIdentifier.self, forKey: .available).uniqueValue
        total = try container.decode(Int.self, forKey: .total)
    }
}


private extension APIAuthorizationResponse.Storage {
    enum CodingKeys: CodingKey {
        case available
        case total
    }
}
