//
//  SearchRequest.swift
//  NCS
//
//  Created by Dang Quyen on 6/2/19.
//  Copyright © 2019 Dang Quyen. All rights reserved.
//

import Foundation

public struct SearchRequest: Requestable {
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
        
        if let filterParam = filter?.keyValue {
            q[filterParam.key] = filterParam.value
        }
        
        q.appendingQueryParameter(key: "channelId", value: channelID)
        q.appendingQueryParameter(key: "maxResults", value: maxResults)
        q.appendingQueryParameter(key: "pageToken", value: pageToken)
        q.appendingQueryParameter(key: "order", value: order)
        q.appendingQueryParameter(key: "type", value: searchType)
        q.appendingQueryParameter(key: "q", value: keyword)
        q.appendingQueryParameter(key: "regionCode", value: regionCode)
        
        if searchType == .video {
            q.appendingQueryParameter(key: "videoCategoryId", value: 10)
        }
        
        return q
    }
    
    // MARK: - Required parameters
    
    public let part: [Part.SearchList]
    
    // MARK: - Option parameters
    
    public let channelID: String?
    public let maxResults: Int?
    public let order: ResultOrder.Search?
    public let pageToken: String?
    public let keyword: String?
    public let searchType: SearchResourceType?
    public let filter: Filter.SearchList?
    public let regionCode: String?
    
    public init(part: [Part.SearchList],
                keyword: String? = nil,
                searchType: SearchResourceType? = nil,
                channelID: String? = nil,
                maxResults: Int? = nil,
                pageToken: String? = nil,
                order: ResultOrder.Search? = nil,
                regionCode: String? = nil,
                filter: Filter.SearchList? = nil) {
        self.part = part
        self.channelID = channelID
        self.maxResults = maxResults
        self.pageToken = pageToken
        self.order = order
        self.keyword = keyword
        self.searchType = searchType
        self.filter = filter
        self.regionCode = regionCode
    }
    
}
