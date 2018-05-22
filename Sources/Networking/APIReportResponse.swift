//
//  APIReportResponse.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

public struct APIReportResponse: Hashable, Decodable {
    public var meta: APIMeta
}


extension APIReportResponse: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = [:]
}
