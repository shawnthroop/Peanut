//
//  APIMarker.Name.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension APIMarker {
    
    /// Possible names of stream markers.
    public enum Name: Hashable {
        case global
        case personal // unified and me
        case mentions
        case channel(Identifier<Channel>)
    }
}


extension APIMarker.Name: RawRepresentable, Codable {
    public var rawValue: String {
        switch self {
        case .global:
            return "global"
        case .personal:
            return "personal"
        case .mentions:
            return "mentions"
        case .channel(let id):
            return "channel:\(id.rawValue)"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "global":
            self = .global
        case "personal", "me", "unified":
            self = .personal
        case "mentions":
            self = .mentions
        default:
            guard let id = Identifier<Channel>(markerName: rawValue) else {
                return nil
            }
            
            self = .channel(id)
        }
    }
}


private extension Identifier where T == Channel {
    init?(markerName name: String) {
        let prefix = name.prefix(8)
        
        guard prefix == "channel:", let value = UniqueIdentifier(rawValue: String(name.suffix(from: prefix.endIndex))) else {
            return nil
        }
        
        self.init(value: value)
    }
}

