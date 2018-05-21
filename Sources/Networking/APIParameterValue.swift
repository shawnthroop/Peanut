//
//  APIParameterValue.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIParameterValue {
    var parameterValue: String { get }
}


extension String: APIParameterValue {
    public var parameterValue: String { return self }
}


extension Int: APIParameterValue {
    public var parameterValue: String { return String(self) }
}


extension Bool: APIParameterValue {
    public var parameterValue: String { return (self == true ? "1" : "0") }
}


extension Array: APIParameterValue where Element == String {
    public var parameterValue: String { return joined(separator: ",") }
}


extension Set: APIParameterValue where Element: APIParameterValue {
    public var parameterValue: String { return map({ $0.parameterValue }).joined(separator: ",") }
}
