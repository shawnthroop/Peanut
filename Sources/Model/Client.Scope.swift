//
//  Client.Scope.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Client {
    
    public enum Scope: Hashable, Codable {
        case basic
        case stream
        case writePost
        case follow
        case updateProfile
        case presence
        case messages(String?)
        case publicMessages(String?)
        case files(String?)
        case polls(String?)
        case email
    }
}


extension Client.Scope {    
    public var userReadableDescription: String {
        switch self {
        case .basic:
            return "See basic information about you"
        case .stream:
            return "Read your post streams"
        case .writePost:
            return "Create and interact with your posts"
        case .follow:
            return "Add and remove follows, mutes, and blocks for you"
        case .updateProfile:
            return "Update your name and other profile information"
        case .presence:
            return "Update your presence"
        case .messages(_):
            return "Send and receive public and private messages"
        case .publicMessages(_):
            return "Send and receive public messages"
        case .files(_):
            return "Manage your files"
        case .polls(_):
            return "Manage your polls"
        case .email:
            return "Access your email address"
        }
    }
}


extension Client.Scope: RawRepresentable {
    public init?(rawValue: String) {
        let separatorRange = rawValue.range(of: ":")
        let base = separatorRange.map({ rawValue[..<$0.lowerBound] }) ?? rawValue[...]
        
        if base.isEmpty {
            return nil
        }
        
        var domain: String? { return separatorRange.map({ String(rawValue[$0.upperBound...]) }) }
        
        switch base {
        case "basic":
            self = .basic
        case "stream":
            self = .stream
        case "write_post":
            self = .writePost
        case "follow":
            self = .follow
        case "update_profile":
            self = .updateProfile
        case "presence":
            self = .presence
        case "messages":
            self = .messages(domain)
        case "public_messages":
            self = .publicMessages(domain)
        case "files":
            self = .files(domain)
        case "polls":
            self = .polls(domain)
        case "email":
            self = .email
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .basic:
            return "basic"
        case .stream:
            return "stream"
        case .writePost:
            return "write_post"
        case .follow:
            return "follow"
        case .updateProfile:
            return "update_profile"
        case .presence:
            return "presence"
        case .messages(let domain):
            return Client.Scope.rawValue("messages", domain: domain)
        case .publicMessages(let domain):
            return Client.Scope.rawValue("public_messages", domain: domain)
        case .files(let domain):
            return Client.Scope.rawValue("files", domain: domain)
        case .polls(let domain):
            return Client.Scope.rawValue("polls", domain: domain)
        case .email:
            return "email"
        }
    }
}


extension Client.Scope: APIParameterValue {
    public var parameterValue: String {
        return rawValue
    }
}


private extension Client.Scope {
    static func rawValue(_ base: String, domain: String?) -> String {
        var base = base
        
        if let domain = domain {
            base += ":\(domain)"
        }
        
        return base
    }
}
