//
//  ApiSession.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017
//

import Foundation
import Alamofire

public class ApiSession {
    
    public static let shared = ApiSession()
    
    private init() {}
    
    public func send<T: Requestable>(_ request: T, closure: @escaping (Result<T.Response, Error>) -> Void) {
        
        let urlRequest = request.makeURLRequest()
//        AF.request(urlRequest).responseString { (response) in
//            if let error = response.error {
//                DispatchQueue.main.async {
//                    closure(.failed(ResponseError.unexpectedResponse(error)))
//                }
//
//                return
//            }
//
//            if let result = response.value {
//                let jsonStr = result.htmlDecoded
//                guard let utf8Data = jsonStr.data(using: String.Encoding.utf8) else {return}
//                do {
//                    let decoder = JSONDecoder()
//                    let data = try decoder.decode(T.Response.self, from: utf8Data)
//                    closure(.success(data))
//                } catch let err {
//                    closure(.failed(ResponseError.unexpectedResponse(err)))
//                }
//            } else{
//                closure(.failed(ResponseError.unexpectedResponse("The response is empty.")))
//            }
//        }
        AF.request(urlRequest).responseDecodable { (response: DataResponse<T.Response, AFError>) in
            if let error = response.error {
                print(error)
                DispatchQueue.main.async {
                    closure(.failed(ResponseError.unexpectedResponse(error)))
                }

                return
            }

            if let result = response.value {
                closure(.success(result))
            } else{
                closure(.failed(ResponseError.unexpectedResponse("The response is empty.")))
            }
        }
    }
}
