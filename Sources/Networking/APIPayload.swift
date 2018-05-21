//
//  APIPayload.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public enum APIPayload: Hashable {
    case json(Data)
    case urlEncodedForm(Data)
}


extension APIPayload {
    init<T: Encodable>(value: T, api: API = .latest) throws {
        try self = .json(JSONEncoder(context: APIEncodingContext(api: api, destination: .remote)).encode(value))
    }
    
    public init?(string str: String, encoding: String.Encoding = .utf8) {
        guard let data = str.data(using: encoding) else {
            return nil
        }
        
        self = .urlEncodedForm(data)
    }
}
