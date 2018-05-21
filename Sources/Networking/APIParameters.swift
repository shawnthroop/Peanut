//
//  APIParameters.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public typealias APIParameters = Dictionary<APIParameterKey, APIParameterValue>


extension Dictionary where Key == APIParameterKey, Value == APIParameterValue {
    subscript<T: APIParameterValue>(key: Key) -> T? {
        get {
            guard let val = self[key] else {
                return nil
            }
            
            return val as? T
        }
        set {
            self[key] = newValue
        }
    }
    
    public var rawValues: [String: String] {
        return reduce(into: [String: String](), { $0[$1.key.rawValue] = $1.value.parameterValue })
    }
}


extension Dictionary where Key == String, Value == String {
    public func asPercentEncodedQuery(withAllowedCharacters allowed: CharacterSet? = nil) -> String {
        var query = ""
        
        if isEmpty {
            return query
        }
        
        let percentEncoded: (String) -> String
        
        if let characters = allowed {
            percentEncoded = { $0.addingPercentEncoding(withAllowedCharacters: characters)! }
        } else {
            percentEncoded = { $0 }
        }
        
        var index = 0
        
        for (key, value) in self {
            query.append("\(index == 0 ? "?" : "&")\(percentEncoded(key))=\(percentEncoded(value))")
            index += 1
        }
        
        return query
    }
    
    public func asPostBody() -> String {
        return map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
}
