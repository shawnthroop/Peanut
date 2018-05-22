//
//  APIObjectResponse.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIObjectResponse<T> {
    public var meta: APIMeta
    public var data: APIObjectResponse<T>.Data
}


extension APIObjectResponse: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(APIMeta.self, forKey: .meta)
        data = try container.decodeIfPresent(Data.self, forKey: .data) ?? .multiple([])
    }
}


extension APIObjectResponse: APIDefaultParametersProvider where T: APIDefaultParametersProvider {
    public static var defaultParameters: APIParameters { return T.defaultParameters }
}

private extension APIObjectResponse {
    enum CodingKeys: CodingKey {
        case meta
        case data
    }
}
