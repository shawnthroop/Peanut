//
//  APIPayload.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public enum APIPayload: Hashable {
    case json(Data)
    case urlEncodedForm(Data)
    case multipartForm(Data, boundary: String)
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
    
    public init(formValues values: [String: String], content: (key: String, data: Data)?) throws {
        var form = MutlipartForm()
        
        for (key, value) in values {
            try form.append(value, forKey: key)
        }
        
        if let (key, data) = content {
            try form.append(data, forKey: key, filename: key)
        }
        
        try form.appendBoundary(isLast: true)
        
        self = .multipartForm(form.data, boundary: form.boundary)
    }
}


private struct MutlipartForm {
    let boundary: String
    private(set) var data: Data
    
    init(boundary: String = .mutlipartFormDataBoundary(), data: Data = Data()) {
        self.boundary = boundary
        self.data = data
    }
    
    mutating func appendBoundary(isLast: Bool = false) throws {
        var ln = "--\(boundary)"
        
        if isLast {
            ln += "--"
        }
        
        try append(ln + .eol)
    }
    
    mutating func append(_ str: String, forKey key: String) throws {
        try append(str.toUTF8EncodedData(), forKey: key, filename: nil)
    }
    
    mutating func append(_ data: Data, forKey key: String, filename: String?) throws {
        try appendBoundary()
        
        var ln = "Content-Disposition: form-data; name=\"\(key)\""
        if let filename = filename {
            ln += "; filename=\"\(filename)\""
        }
        
        try append(ln + .eol + .eol)
        append(data)
        try append(.eol)
    }
    
    private mutating func append(_ str: String) throws {
        try append(str.toUTF8EncodedData())
    }
    
    private mutating func append(_ data: Data) {
        self.data.append(data)
    }
}


private extension MutlipartForm {
    enum EncodingError: Error {
        case utf8EncodingFailure(String)
    }
}


private extension String {
    static let eol = "\r\n"
    
    static func mutlipartFormDataBoundary() -> String {
        return "terryloves" + UUID().uuidString
    }
    
    func toUTF8EncodedData() throws -> Data {
        guard let encoded = data(using: .utf8) else {
            throw MutlipartForm.EncodingError.utf8EncodingFailure(self)
        }
        
        return encoded
    }
}
