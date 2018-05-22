//
//  Poll.Option.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll {
    
    public struct Option: Hashable {
        public var text: String
        public var index: Int
        public var isYourResponse: Bool
        public var response: Poll.Response?
    }
}


extension Poll.Option: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        index = try container.decode(Int.self, forKey: .index)
        isYourResponse = try decodeIsYourResponse(from: container)
//        isYourResponse = try container.decodeIfPresent(Int.self, forKey: .isYourResponse).map({ $0 == 0 ? false : true }) ?? false
//        isYourResponse = try container.decodeIfPresent(Bool.self, forKey: .isYourResponse) ?? false
        
        response = try container.decodeIfPresent(Int.self, forKey: .responseCount).map { count in
            return Poll.Response(count: count, ids: try container.decodeIfPresent(Set<Poll.ID>.self, forKey: .responseIDs) ?? Set())
        }
    }
}


extension Poll.Option: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(index, forKey: .index)
        
        if isYourResponse {
            try container.encode(true, forKey: .isYourResponse)
        }
        
        try container.encodeIfPresent(response?.count, forKey: .responseCount)
        try container.encodeIfPresent(response?.ids, forKey: .responseIDs)
    }
}


private extension Poll.Option {
    enum CodingKeys: String, CodingKey {
        case text
        case index          = "position"
        case isYourResponse = "is_your_response"
        case responseCount  = "respondents"
        case responseIDs    = "respondent_ids"
    }
}


private func decodeIsYourResponse(from container: KeyedDecodingContainer<Poll.Option.CodingKeys>) throws -> Bool {
    var result: Bool?
    
    if container.contains(.isYourResponse) {
        do {
            let isYourResponse = try container.decode(Int.self, forKey: .isYourResponse)
            result = isYourResponse == 0 ? false : true
            
        } catch {
            guard let err = error as? DecodingError, case .typeMismatch = err else {
                throw error
            }
        }
        
        if result == nil {
            result = try container.decode(Bool.self, forKey: .isYourResponse)
        }
    }
    
    return result ?? false
}
