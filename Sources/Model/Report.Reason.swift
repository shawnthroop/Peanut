//
//  Report.Reason.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Report {
    
    public enum Reason: Hashable {
        case soliciting
        case accountType
        case nsfw
        case userAbuse
    }
}


extension Report.Reason {
    public var userReadableDescription: String {
        switch self {
        case .soliciting:
            return "Unwelcome soliciting"
        case .accountType:
            return "Account is acting in a behavior counter to the purposes of its account type"
        case .nsfw:
            return "Unflagged mature material according to the community guidelines"
        case .userAbuse:
            return "Use of the API or network to abuse another user"
        }
    }
}


extension Report.Reason: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "soliciting":
            self = .soliciting
        case "account_type":
            self = .accountType
        case "nsfw":
            self = .nsfw
        case "user_abuse":
            self = .userAbuse
            
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .soliciting:
            return "soliciting"
        case .accountType:
            return "account_type"
        case .nsfw:
            return "nsfw"
        case .userAbuse:
            return "user_abuse"
        }
    }
}
