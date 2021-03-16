//
//  VideoListChannelRequest.swift
//  NCS
//
//  Created by Dang Quyen on 5/9/19.
//  Copyright © 2019 Dang Quyen. All rights reserved.
//

import Foundation
public struct VideoListChannelRequest: Requestable {
    public typealias Response = SearchList
    
    public var path: String {
        return "search"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var isAuthorizedRequest: Bool {
        return false
    }
    
    
    public var queryParameters: [String : Any] {
        var q: [String: Any] = [:]
        let part = self.part
            .map { $0.rawValue }
            .joined(separator: ",")
        q.appendingQueryParameter(key: "part", value: part)
        q.appendingQueryParameter(key: "type", value: "video")
        q.appendingQueryParameter(key: "channelId", value: channelID)
        q.appendingQueryParameter(key: "maxResults", value: maxResults)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "order", value: order)
        
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.SearchList]
    
    // MARK: - Option parameters
    
    public let channelID: String?
    public let maxResults: Int?
    public let order: ResultOrder.Search?
    public let pageToken: String?
    
    public init(part: [Part.SearchList],
                channelID: String? = nil,
                maxResults: Int? = nil,
                pageToken: String? = nil,
                order: ResultOrder.Search? = nil) {
        self.part = part
        self.channelID = channelID
        self.maxResults = maxResults
        self.pageToken = pageToken
        self.order = order
    }
    
}
