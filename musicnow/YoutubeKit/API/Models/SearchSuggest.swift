//
//  SearchSuggest.swift
//  NCS
//
//  Created by Dang Quyen on 5/31/19.
//  Copyright © 2019 Dang Quyen. All rights reserved.
//

import Foundation

struct SearchSuggest: Decodable {
    let firstString: String
    let stringArray: [String]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        firstString = try container.decode(String.self)
        stringArray = try container.decode([String].self)
    }
}

enum SearchTermElement: Codable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(SearchTermElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SearchTermElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

typealias SearchTerm = [SearchTermElement]
