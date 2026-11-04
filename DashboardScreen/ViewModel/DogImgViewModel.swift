//
//  DogImgViewModel.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import UIKit

@MainActor
class DogImgViewModel {
    private var dogImgData:DogImgModel?
    
    func getDogImgData() async throws -> DogImgModel {
        do {
            let data = try await APICaller.getDogImg()
            self.dogImgData = data
            return data
        } catch {
            throw error
        }
    }
    
  //Image Fetching 
    func getDogImage() async throws -> UIImage {
        let dogData = try await getDogImgData()
        return try await APICaller.downloadImage(from: dogData.message)
    }
}

