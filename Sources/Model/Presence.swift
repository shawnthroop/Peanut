//
//  Presence.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

public struct Presence: Hashable, Codable {
    public var id: User.ID
    public var lastSeen: Date?
    public var status: Status
}


public extension APIParameterKey {
    public static let updatePresence = APIParameterKey("update_presence")
}


extension Presence: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = [:]
}


private extension Presence {
    enum CodingKeys: String, CodingKey {
        case id
        case lastSeen   = "last_seen_at"
        case status     = "presence"
    }
}
