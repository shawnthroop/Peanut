//
//  API.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public enum API {
    case v0
}


extension API {
    public static let latest: API = .v0
    
    public var root: String {
        switch self {
        case .v0:
            return "https://api.pnut.io/v0"
        }
    }
}
