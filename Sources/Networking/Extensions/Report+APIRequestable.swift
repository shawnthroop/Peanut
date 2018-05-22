//
//  Report+APIRequestable.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Report: APIRequestable {
    public typealias Response = APIReportResponse
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, method: .post, path: "")
        
        switch self {
        case .post(let id, _):
            result.append("posts", id.rawValue)
        case .message(let message, let channel, _):
            result.append("channels", channel.rawValue, "messages", message.rawValue)
        }
        
        result.append("report")
        
        return result
    }
    
    public func payload(for api: API) throws -> APIPayload? {
        let reason: Report.Reason
        
        switch self {
        case .post(_, let r):
            reason = r
        case .message(_, _, let r):
            reason = r
        }
        
        let params: APIParameters = [.reason: reason.rawValue]
        return APIPayload(string: params.rawValues.asPostBody(), encoding: .utf8)
    }

}


private extension APIParameterKey {
    static let reason = APIParameterKey("reason")
}
