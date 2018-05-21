//
//  APIDataResponse.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIDataResponse<T> {
    public var meta: APIMeta
    public var data: APIDataResponse<T>.Data
}


extension APIDataResponse: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(APIMeta.self, forKey: .meta)
        data = try container.decodeIfPresent(Data.self, forKey: .data) ?? .multiple([])
    }
}


extension APIDataResponse: APIDefaultParametersProvider where T: APIDefaultParametersProvider {
    public static var defaultParameters: APIParameters { return T.defaultParameters }
}

private extension APIDataResponse {
    enum CodingKeys: CodingKey {
        case meta
        case data
    }
}
