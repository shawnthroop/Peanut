//
//  APIResponse.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public enum APIResponse<T> {
    case success(T)
    case failure(APIError)
}


extension APIResponse {
    public var success: T? {
        if case let .success(value) = self {
            return value
        }
        
        return nil
    }
    
    public var failure: APIError? {
        if case let .failure(error) = self {
            return error
        }
        
        return nil
    }
}


extension APIResponse: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var responseError: APIResponseError?
        
        do {
            responseError = try container.decodeIfPresent(APIResponseError.self, forKey: .meta)
            
        } catch let error as DecodingError {
            guard case let .keyNotFound(key as APIResponseError.CodingKeys, _) = error, key == .message else {
                throw error
            }
            
        } catch {
            throw error
        }
        
        if let error = responseError {
            self = .failure(.response(error))
            
        } else {
            self = .success(try T(from: decoder))
        }
    }
}

extension APIResponse where T: Decodable {
    
    /// Creates a response from remote data and error returned from a URLSessionDataTask.
    public init(remote data: Data?, error: Error?, api: API = .latest) {
        if let data = data {
            do {
                self = try JSONDecoder(context: APIDecodingContext(api: api, source: .remote)).decode(APIResponse<T>.self, from: data)
                
            } catch let err as DecodingError {
                self = .failure(.parse(err))
            } catch let err {
                self = .failure(.other(err))
            }
            
        } else {
            switch error {
            case .some(let err as URLError):
                self = .failure(.network(err))
            case .some(let err):
                self = .failure(.other(err))
            default:
                fatalError("APIResponse - both data and error are nil")
            }
        }
    }
}


private extension APIResponse {
    enum CodingKeys: CodingKey {
        case meta
    }
}
