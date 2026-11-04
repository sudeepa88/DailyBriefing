//
//  DogImgModel.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//


import Foundation

struct DogImgModel: Codable {
    let message: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
}
