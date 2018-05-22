//
//  Presence.Status.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

public extension Presence {
    
    public enum Status: Hashable, Codable {
        case online
        case offline
        case custom(String)
    }
}


extension Presence.Status: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "online":
            self = .online
        case "offline":
            self = .offline
        default:
            self = .custom(limited(rawValue))
        }
    }
    
    public var rawValue: String {
        switch self {
        case .online:
            return "online"
        case .offline:
            return "offline"
        case .custom(let str):
            return str
        }
    }
}


extension Presence.Status: APIParameterValue {
    public var parameterValue: String {
        switch self {
        case .online:
            return "1"
        case .offline:
            return "0"
        case .custom(let str):
            return limited(str)
        }
    }
}


private func limited(_ str: String, by count: Int = 100) -> String {
    let range = str.unicodeScalars.startIndex..<str.unicodeScalars.endIndex
    let limit = str.unicodeScalars.index(range.lowerBound, offsetBy: count, limitedBy: range.upperBound)
    
    return String(str.unicodeScalars[..<(limit ?? range.upperBound)])
}
