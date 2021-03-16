//
//  FeautureChannel.swift
//  musicnow
//
//  Created by QuyenDang on 20/02/2021.
//

import Foundation




public struct FeautureChannel: Codable {
    public let id: String
    public let title: String
    public var index: Int
    public var shuffle: Bool
}


public struct FeautureChannelList: Codable {
    public var items: [FeautureChannel]
}
