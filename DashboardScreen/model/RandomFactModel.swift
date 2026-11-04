//
//  RandomFactModel.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import Foundation


struct RandomFactModel: Codable {
    let id: String
    let text: String
    let source: String
    let sourceURL: String
    let language: String
    let permalink: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case source = "source"
        case sourceURL = "source_url"
        case language = "language"
        case permalink = "permalink"
    }
}

